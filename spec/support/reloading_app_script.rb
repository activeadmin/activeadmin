# frozen_string_literal: true

# Boots a copy of the test app with class reloading enabled and exercises
# Active Admin's reloader through real requests. It runs in a child process
# because reloading must be configured before Rails boots, which the main
# test process has already done with reloading off.
#
# Usage: ruby spec/support/reloading_app_script.rb <path to app copy>
#
# Prints a JSON object of observations to stdout for the calling spec to
# assert on.

require "json"
require_relative "simplecov_helper"

ActiveAdmin::TestSupport::SimpleCovHelper.start(["reloading", ENV["TEST_ENV_NUMBER"]].join(" ").rstrip)

app_dir = ARGV.fetch(0)

ENV["RAILS_ENV"] = "test"
ENV["CLASS_RELOADING"] = "true"

require File.join(app_dir, "config/environment")

ActiveRecord::Schema.verbose = false
load Rails.root.join("db/schema.rb").to_s

# Authentication isn't what this script tests, and the initializer that
# enables it doesn't run again on reload, so turning it off here sticks.
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

session = ActionDispatch::Integration::Session.new(Rails.application)
results = {}

def write_file(path, contents)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, contents)
end

posts_menu = %r{<a[^>]+href="/admin/posts"}

session.get "/admin"
results["menu_before_registering"] = session.response.body.match?(posts_menu)

write_file Rails.root.join("app/admin/posts.rb"), <<~RUBY
  ActiveAdmin.register Post do
    permit_params :title
  end
RUBY

session.get "/admin"
results["menu_after_registering"] = session.response.body.match?(posts_menu)

session.post "/admin/posts", params: { post: { title: "A" } }
results["create_status"] = session.response.status
session.follow_redirect! if session.response.redirect?
results["created_flash"] = session.response.body.include?("Post was successfully created")

model_path = Rails.root.join("app/models/post.rb")
write_file model_path, File.read(model_path).sub(/^(class Post .+)$/, "\\1\n  validates_presence_of :title")

session.post "/admin/posts", params: { post: { title: "" } }
results["invalid_status"] = session.response.status
results["validation_error"] = session.response.body.include?("can&#39;t be blank") ||
  session.response.body.include?("can't be blank")

puts "RESULTS=#{results.to_json}"
