# Rails template to build the sample app for specs

webpacker_app = ENV["BUNDLE_GEMFILE"] == File.expand_path("../../gemfiles/rails_61_webpacker/Gemfile", __dir__)

if webpacker_app
  create_file "app/javascript/packs/some-random-css.css"
  create_file "app/javascript/packs/some-random-js.js"
else
  create_file "app/assets/stylesheets/some-random-css.css"
  create_file "app/assets/javascripts/some-random-js.js"
end

create_file "app/assets/images/a/favicon.ico"

initial_timestamp = Time.now.strftime("%Y%M%d%H%M%S").to_i

template File.expand_path("templates/migrations/create_posts.tt", __dir__), "db/migrate/#{initial_timestamp}_create_posts.rb"

copy_file File.expand_path("templates/models/post.rb", __dir__), "app/models/post.rb"
copy_file File.expand_path("templates/post_decorator.rb", __dir__), "app/models/post_decorator.rb"
copy_file File.expand_path("templates/post_poro_decorator.rb", __dir__), "app/models/post_poro_decorator.rb"

template File.expand_path("templates/migrations/create_blog_posts.tt", __dir__), "db/migrate/#{initial_timestamp + 1}_create_blog_posts.rb"

copy_file File.expand_path("templates/models/blog/post.rb", __dir__), "app/models/blog/post.rb"

template File.expand_path("templates/migrations/create_profiles.tt", __dir__), "db/migrate/#{initial_timestamp + 2}_create_profiles.rb"

copy_file File.expand_path("templates/models/user.rb", __dir__), "app/models/user.rb"

template File.expand_path("templates/migrations/create_users.tt", __dir__), "db/migrate/#{initial_timestamp + 3}_create_users.rb"

copy_file File.expand_path("templates/models/profile.rb", __dir__), "app/models/profile.rb"

copy_file File.expand_path("templates/models/publisher.rb", __dir__), "app/models/publisher.rb"

template File.expand_path("templates/migrations/create_categories.tt", __dir__), "db/migrate/#{initial_timestamp + 4}_create_categories.rb"

copy_file File.expand_path("templates/models/category.rb", __dir__), "app/models/category.rb"

copy_file File.expand_path("templates/models/store.rb", __dir__), "app/models/store.rb"
template File.expand_path("templates/migrations/create_stores.tt", __dir__), "db/migrate/#{initial_timestamp + 5}_create_stores.rb"

template File.expand_path("templates/migrations/create_tags.tt", __dir__), "db/migrate/#{initial_timestamp + 6}_create_tags.rb"

copy_file File.expand_path("templates/models/tag.rb", __dir__), "app/models/tag.rb"

template File.expand_path("templates/migrations/create_taggings.tt", __dir__), "db/migrate/#{initial_timestamp + 7}_create_taggings.rb"

copy_file File.expand_path("templates/models/tagging.rb", __dir__), "app/models/tagging.rb"

gsub_file "config/environments/test.rb", /  config.cache_classes = true/, <<-RUBY

  config.cache_classes = !ENV['CLASS_RELOADING']
  config.action_mailer.default_url_options = {host: 'example.com'}

  config.active_record.maintain_test_schema = false

RUBY

unless webpacker_app
  inject_into_file "config/environments/test.rb", after: "  config.action_mailer.default_url_options = {host: 'example.com'}" do
    "\n  config.assets.precompile += %w( some-random-css.css some-random-js.js a/favicon.ico )\n"
  end
end

gsub_file "config/boot.rb", /^.*BUNDLE_GEMFILE.*$/, <<-RUBY
  ENV['BUNDLE_GEMFILE'] = "#{File.expand_path(ENV['BUNDLE_GEMFILE'])}"
RUBY

# Setup webpacker if necessary
if webpacker_app
  rails_command "webpacker:install"
  gsub_file "config/webpacker.yml", /^(.*)extract_css.*$/, '\1extract_css: true' if ENV["RAILS_ENV"] == "test"
end

# Setup Active Admin
generate "active_admin:install --no_interaction#{" --use-webpacker" if webpacker_app}"

# Force strong parameters to raise exceptions
inject_into_file "config/application.rb", after: "class Application < Rails::Application" do
  "\n    config.action_controller.action_on_unpermitted_parameters = :raise\n"
end

# Add some translations
append_file "config/locales/en.yml", File.read(File.expand_path("templates/en.yml", __dir__))

# Add predefined admin resources
directory File.expand_path("templates/admin", __dir__), "app/admin"

# Add predefined policies
directory File.expand_path("templates/policies", __dir__), "app/policies"

# Require turbolinks if necessary
if ENV["BUNDLE_GEMFILE"] == File.expand_path("../../gemfiles/rails_61_turbolinks/Gemfile", __dir__)
  append_file "app/assets/javascripts/active_admin.js", "//= require turbolinks\n"
end

if ENV["RAILS_ENV"] != "test"
  inject_into_file "config/routes.rb", "\n  root to: redirect('admin')", after: /.*routes.draw do/
end

rails_command "db:drop db:create db:migrate", env: ENV["RAILS_ENV"]

if ENV["RAILS_ENV"] == "test"
  inject_into_file "config/database.yml", "<%= ENV['TEST_ENV_NUMBER'] %>", after: "test.sqlite3"

  require "parallel_tests"
  ParallelTests.determine_number_of_processes(nil).times do |n|
    copy_file File.expand_path("db/test.sqlite3", destination_root), "db/test.sqlite3#{n + 1}"
  end
end

git add: "."
git commit: "-m 'Bare application'"
