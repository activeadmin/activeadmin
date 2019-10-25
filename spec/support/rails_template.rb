# Rails template to build the sample app for specs

create_file 'app/assets/stylesheets/some-random-css.css'
create_file 'app/assets/javascripts/some-random-js.js'
create_file 'app/assets/images/a/favicon.ico'

require 'active_admin/dependency'

timestamps = ActiveAdmin::Dependency.rails?('>= 6.1.0.a') ? '--timestamps' : 'created_at:datetime updated_at:datetime'

generate :migration, 'create_posts title:string body:text published_date:date author_id:integer ' +
  "position:integer custom_category_id:integer starred:boolean foo_id:integer #{timestamps}"

copy_file File.expand_path('templates/models/post.rb', __dir__), 'app/models/post.rb'
copy_file File.expand_path('templates/post_decorator.rb', __dir__), 'app/models/post_decorator.rb'

generate :migration, 'create_blog_posts title:string body:text published_date:date author_id:integer ' +
  "position:integer custom_category_id:integer starred:boolean foo_id:integer #{timestamps}"

copy_file File.expand_path('templates/models/blog/post.rb', __dir__), 'app/models/blog/post.rb'

generate :migration, "create_profiles user_id:integer bio:text #{timestamps}"

copy_file File.expand_path('templates/models/user.rb', __dir__), 'app/models/user.rb'

generate :migration, "create_users type:string first_name:string last_name:string username:string age:integer encrypted_password:string #{timestamps}"

copy_file File.expand_path('templates/models/profile.rb', __dir__), 'app/models/profile.rb'

generate :model, 'publisher --migration=false --parent=User'

generate :migration, "create_categories name:string description:text #{timestamps}"

copy_file File.expand_path('templates/models/category.rb', __dir__), 'app/models/category.rb'

generate :model, 'store name:string user_id:integer'

generate :migration, "create_tags name:string #{timestamps}"

copy_file File.expand_path('templates/models/tag.rb', __dir__), 'app/models/tag.rb'

generate :migration, "create_taggings post_id:integer tag_id:integer position:integer #{timestamps}"

copy_file File.expand_path('templates/models/tagging.rb', __dir__), 'app/models/tagging.rb'

gsub_file 'config/environments/test.rb', /  config.cache_classes = true/, <<-RUBY

  config.cache_classes = !ENV['CLASS_RELOADING']
  config.action_mailer.default_url_options = {host: 'example.com'}
  config.assets.precompile += %w( some-random-css.css some-random-js.js a/favicon.ico )

  config.active_record.maintain_test_schema = false

RUBY

gsub_file 'config/boot.rb', /^.*BUNDLE_GEMFILE.*$/, <<-RUBY
  ENV['BUNDLE_GEMFILE'] = "#{File.expand_path(ENV['BUNDLE_GEMFILE'])}"
RUBY

# Setup Active Admin
generate 'active_admin:install'

# Force strong parameters to raise exceptions
inject_into_file 'config/application.rb', after: 'class Application < Rails::Application' do
  "\n    config.action_controller.action_on_unpermitted_parameters = :raise\n"
end

# Add some translations
append_file 'config/locales/en.yml', File.read(File.expand_path('templates/en.yml', __dir__))

# Add predefined admin resources
directory File.expand_path('templates/admin', __dir__), 'app/admin'

# Add predefined policies
directory File.expand_path('templates/policies', __dir__), 'app/policies'

# Require turbolinks if necessary
if ENV["BUNDLE_GEMFILE"] == File.expand_path("../../gemfiles/rails_60_turbolinks/Gemfile", __dir__)
  append_file 'app/assets/javascripts/active_admin.js', "//= require turbolinks\n"
end

if ENV['RAILS_ENV'] != 'test'
  inject_into_file 'config/routes.rb', "\n  root to: redirect('admin')", after: /.*routes.draw do/
end

rake "db:drop db:create db:migrate", env: ENV['RAILS_ENV']

if ENV['RAILS_ENV'] == 'test'
  inject_into_file 'config/database.yml', "<%= ENV['TEST_ENV_NUMBER'] %>", after: 'test.sqlite3'

  rake "parallel:drop parallel:create parallel:load_schema", env: ENV['RAILS_ENV']
end

git add: "."
git commit: "-m 'Bare application'"
