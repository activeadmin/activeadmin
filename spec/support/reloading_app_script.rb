# frozen_string_literal: true

# Boots a copy of the test app with class reloading enabled and exercises
# Active Admin's reloader the way a developer would: signing in through the
# login form, clicking through the menu and submitting forms, while files in
# the app change. It runs in a child process because reloading must be
# configured before Rails boots, which the main test process has already
# done with reloading off.
#
# Authentication stays on, as the test app configures it, so signing in and
# the session are exercised across reloads too.
#
# Usage: ruby spec/support/reloading_app_script.rb <path to app copy>
#
# Prints a JSON object of observations to stdout for the calling spec to
# assert on.

require "json"
if ENV["COVERAGE"] == "true"
  require "simplecov"
  SimpleCov.command_name ["reloading", ENV["TEST_ENV_NUMBER"]].compact.join(" ").rstrip
  SimpleCov.start { finalize_merge false }
end

app_dir = ARGV.fetch(0)

ENV["RAILS_ENV"] = "test"
ENV["CLASS_RELOADING"] = "true"

require File.join(app_dir, "config/environment")
require "capybara"

ActiveRecord::Schema.verbose = false
load Rails.root.join("db/schema.rb").to_s

AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password")

browser = Capybara::Session.new(:rack_test, Rails.application)
results = {}

def write_file(path, contents)
  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, contents)
end

def sign_in(browser)
  browser.visit "/admin"
  browser.fill_in "Email", with: "admin@example.com"
  browser.fill_in "Password", with: "password"
  browser.click_on "Sign In"
end

def posts_menu_item?(browser)
  browser.has_css?("#main-menu li a", exact_text: "Posts")
end

sign_in(browser)
results["signed_in_before_registering"] = browser.has_css?("#main-menu li a", exact_text: "Dashboard")
results["menu_before_registering"] = posts_menu_item?(browser)

write_file Rails.root.join("app/admin/posts.rb"), <<~RUBY
  ActiveAdmin.register Post do
    permit_params :custom_category_id, :author_id, :title,
      :body, :position, :published_date, :starred
  end
RUBY

browser.visit "/admin"
results["signed_in_after_registering"] = browser.has_css?("#main-menu li a", exact_text: "Dashboard")
results["menu_after_registering"] = posts_menu_item?(browser)

browser.find("#main-menu li a", exact_text: "Posts").click
browser.click_on "New Post"
browser.fill_in "Title", with: "A"
browser.click_on "Create Post"
results["created_flash"] = browser.has_text?("Post was successfully created")

# Establish that the same form accepts a blank title before the model changes.
browser.visit "/admin/posts/new"
browser.fill_in "Title", with: ""
browser.click_on "Create Post"
results["blank_title_created_before_validation"] = browser.has_text?("Post was successfully created")
results["post_titles_before_validation"] = Post.order(:id).pluck(:title)

model_path = Rails.root.join("app/models/post.rb")
write_file model_path, File.read(model_path).sub(/^(class Post .+)$/, "\\1\n  validates_presence_of :title")

browser.visit "/admin/posts/new"
browser.fill_in "Title", with: ""
browser.click_on "Create Post"
results["invalid_status"] = browser.status_code
results["validation_error"] = browser.has_css?(".inline-errors", text: "can't be blank")
results["created_after_invalid"] = browser.has_text?("Post was successfully created")
results["post_count_after_invalid"] = Post.count
results["menu_after_model_change"] = posts_menu_item?(browser)

# The reloaded controller must still be able to create a valid record in the
# same session, not just reject invalid submissions.
browser.visit "/admin/posts/new"
browser.fill_in "Title", with: "After reload"
browser.click_on "Create Post"
results["created_after_model_change"] = browser.has_text?("Post was successfully created")
results["post_titles"] = Post.order(:id).pluck(:title)

puts "RESULTS=#{results.to_json}"
