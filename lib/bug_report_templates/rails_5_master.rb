begin
  require 'bundler/inline'
rescue LoadError => e
  STDERR.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true) do
  source 'https://rubygems.org'

  gem 'rails', require: false
  gem 'sqlite3', platform: :mri

  gem 'activerecord-jdbcsqlite3-adapter',
      git: 'https://github.com/jruby/activerecord-jdbc-adapter',
      branch: 'rails-5',
      platform: :jruby

  if ENV['ACTIVE_ADMIN_PATH']
    gem 'activeadmin', path: ENV['ACTIVE_ADMIN_PATH'], require: false
  else
    gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin', require: false
  end

  gem 'inherited_resources', '~> 1.7', require: false
end

# prepare active_record database
require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :active_admin_comments, force: true do |_t|
  end

  # Add your schema here
  create_table :your_models, force: true do |t|
    t.string :name
  end
end

# prepare Rails app
require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_admin'

class ApplicationController < ActionController::Base
end

class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
  config.logger = Logger.new(STDOUT)

  secrets.secret_token = 'secret_token'
  secrets.secret_key_base = 'secret_key_base'

  config.eager_load = false
end

# create models
class YourModel < ActiveRecord::Base
end

# configure active_admin
ActiveAdmin.setup do |config|
  # Authentication disabled by default. Override if necessary
  config.authentication_method = false
  config.current_user_method = false
end

# initialize app
Rails.application.initialize!

# register pages and resources
ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content do
    'Test Me'
  end
end

ActiveAdmin.register YourModel do
end

# draw active_admin routes
Rails.application.routes.draw do
  ActiveAdmin.routes(self)
end

# prepare tests
require 'minitest/autorun'
require 'rack/test'

# Replace this with the code necessary to make your test fail.
class BugTest < Minitest::Test
  include Rack::Test::Methods

  def test_admin_root_success?
    get '/admin'
    assert last_response.ok?
    assert_match 'Test Me', last_response.body # has content
    assert_match 'Your Models', last_response.body # has 'Your Models' in menu
  end

  def test_admin_your_models
    YourModel.create! name: 'John Doe'
    get '/admin/your_models'
    assert last_response.ok?
    assert_match 'John Doe', last_response.body # has created row
  end

  private

  def app
    Rails.application
  end
end
