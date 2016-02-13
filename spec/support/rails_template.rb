# Rails template to build the sample app for specs

# Create a cucumber database and environment
copy_file File.expand_path('../templates/cucumber.rb', __FILE__),                'config/environments/cucumber.rb'
copy_file File.expand_path('../templates/cucumber_with_reloading.rb', __FILE__), 'config/environments/cucumber_with_reloading.rb'

gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"
gsub_file 'config/database.yml', /\z/, "\ncucumber:\n  <<: *test\n  database: db/cucumber.sqlite3"
gsub_file 'config/database.yml', /\z/, "\ncucumber_with_reloading:\n  <<: *test\n  database: db/cucumber.sqlite3"

if File.exists? 'config/secrets.yml'
  gsub_file 'config/secrets.yml', /\z/, "\ncucumber:\n  secret_key_base: #{'o' * 128}"
  gsub_file 'config/secrets.yml', /\z/, "\ncucumber_with_reloading:\n  secret_key_base: #{'o' * 128}"
end

generate :model, 'post title:string body:text published_at:datetime author_id:integer ' +
  'position:integer custom_category_id:integer starred:boolean foo_id:integer'
create_file 'app/models/post.rb', <<-RUBY.strip_heredoc, force: true
  class Post < ActiveRecord::Base
    belongs_to :category, foreign_key: :custom_category_id
    belongs_to :author, class_name: 'User'
    has_many :taggings
    accepts_nested_attributes_for :author
    accepts_nested_attributes_for :taggings

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :id, :title, :body, :starred, :author, :position, :published_at, :author_id, :custom_category_id
    end
  end
RUBY
copy_file File.expand_path('../templates/post_decorator.rb', __FILE__), 'app/models/post_decorator.rb'

generate :model, 'blog/post title:string body:text published_at:datetime author_id:integer ' +
  'position:integer custom_category_id:integer starred:boolean foo_id:integer'
create_file 'app/models/blog/post.rb', <<-RUBY.strip_heredoc, force: true
  class Blog::Post < ActiveRecord::Base
    belongs_to :category, foreign_key: :custom_category_id
    belongs_to :author, class_name: 'User'
    has_many :taggings
    accepts_nested_attributes_for :author
    accepts_nested_attributes_for :taggings

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :title, :body, :starred, :author, :position, :published_at, :author_id, :custom_category_id
    end
  end
RUBY

generate :model, 'profile user_id:integer bio:text'

generate :model, 'user type:string first_name:string last_name:string username:string age:integer'
create_file 'app/models/user.rb', <<-RUBY.strip_heredoc, force: true
  class User < ActiveRecord::Base
    has_many :posts, foreign_key: 'author_id'
    has_one :profile
    accepts_nested_attributes_for :profile, allow_destroy: true

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :first_name, :last_name, :username,  :age
    end

    def display_name
      "\#{first_name} \#{last_name}"
    end
  end
RUBY

create_file 'app/models/profile.rb', <<-RUBY.strip_heredoc, force: true
  class Profile < ActiveRecord::Base
    belongs_to :user
  end
RUBY

generate :model, 'publisher --migration=false --parent=User'

generate :model, 'category name:string description:text'
create_file 'app/models/category.rb', <<-RUBY.strip_heredoc, force: true
  class Category < ActiveRecord::Base
    has_many :posts, foreign_key: :custom_category_id
    has_many :authors, through: :posts
    accepts_nested_attributes_for :posts

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :name
    end
  end
RUBY

generate :model, 'store name:string'

# Generate a model with string ids
generate :model, 'tag name:string'
gsub_file Dir['db/migrate/*_create_tags.rb'].first, /\:tags do .*/, <<-RUBY.strip_heredoc
  :tags, id: false, primary_key: :id do |t|
    t.string :id
RUBY
create_file 'app/models/tag.rb', <<-RUBY.strip_heredoc, force: true
  class Tag < ActiveRecord::Base
    self.primary_key = :id
    before_create :set_id

    private
    def set_id
      self.id = SecureRandom.uuid
    end

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :name
    end
  end
RUBY

generate :model, 'tagging post_id:integer tag_id:integer'
create_file 'app/models/tagging.rb', <<-RUBY.strip_heredoc, force: true
  class Tagging < ActiveRecord::Base
    belongs_to :post
    belongs_to :tag
  end
RUBY

inject_into_file 'config/environments/test.rb', <<-RUBY, after: 'config.cache_classes = true'

  config.action_mailer.default_url_options = {host: 'example.com'}
  config.assets.digest = false

RUBY

# Add our local Active Admin to the load path
inject_into_file 'config/environment.rb', <<-RUBY, after: "require File.expand_path('../application', __FILE__)"

$LOAD_PATH.unshift '#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}'
require 'active_admin'

RUBY

# Force strong parameters to raise exceptions
inject_into_file 'config/application.rb', <<-RUBY, after: 'class Application < Rails::Application'

    config.action_controller.action_on_unpermitted_parameters = :raise if Rails::VERSION::MAJOR >= 4

RUBY

# Add some translations
append_file 'config/locales/en.yml', File.read(File.expand_path('../templates/en.yml', __FILE__))

# Add predefined admin resources
directory File.expand_path('../templates/admin', __FILE__), 'app/admin'

# Add predefined policies
directory File.expand_path('../templates/policies', __FILE__), 'app/policies'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

generate 'active_admin:install'

if ENV['RAILS_ENV'] != 'test'
  inject_into_file 'config/routes.rb', "\n  root to: redirect('admin')", after: /.*routes.draw do/
end

remove_file 'public/index.html' if File.exists? 'public/index.html' # remove once Rails 3.2 support is dropped

# Devise master doesn't set up its secret key on Rails 4.1
# https://github.com/plataformatec/devise/issues/2554
gsub_file 'config/initializers/devise.rb', /# config.secret_key =/, 'config.secret_key ='

rake 'db:migrate db:test:prepare'
run '/usr/bin/env RAILS_ENV=cucumber rake db:migrate'

if ENV['INSTALL_PARALLEL']
  inject_into_file 'config/database.yml', "<%= ENV['TEST_ENV_NUMBER'] %>", after: 'test.sqlite3'
  inject_into_file 'config/database.yml', "<%= ENV['TEST_ENV_NUMBER'] %>", after: 'cucumber.sqlite3', force: true

  # Note: this is hack!
  # Somehow, calling parallel_tests tasks from Rails generator using Thor does not work ...
  # RAILS_ENV variable never makes it to parallel_tests tasks.
  # We need to call these tasks in the after set up hook in order to create cucumber DBs + run migrations on test & cucumber DBs
  create_file 'lib/tasks/parallel.rake', <<-RUBY.strip_heredoc
    namespace :parallel do
      def run_in_parallel(cmd, options)
        count = "-n #{options[:count]}" if options[:count]
        executable = 'parallel_test'
        command = "#{executable} --exec '#{cmd}' #{count} #{'--non-parallel' if options[:non_parallel]}"
        abort unless system(command)
      end

      desc "create cucumber databases via db:create --> parallel:create_cucumber_db[num_cpus]"
      task :create_cucumber_db, :count do |t, args|
        run_in_parallel("rake db:create RAILS_ENV=cucumber", args)
      end

      desc "load dumped schema for cucumber databases"
      task :load_schema_cucumber_db, :count do |t,args|
        run_in_parallel("rake db:schema:load RAILS_ENV=cucumber", args)
      end
    end
  RUBY
end
