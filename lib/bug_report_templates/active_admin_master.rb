begin
  require 'bundler/inline'
rescue LoadError => e
  STDERR.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true) do
  source 'https://rubygems.org'

  # Use local changes or ActiveAdmin master.
  if ENV['ACTIVE_ADMIN_PATH']
    gem 'activeadmin', path: ENV['ACTIVE_ADMIN_PATH'], require: false
  else
    gem 'activeadmin', github: 'activeadmin/activeadmin', require: false
  end

  # Change Rails version if necessary.
  gem 'rails', '~> 5.1.0'

  gem 'sass-rails'
  gem 'sqlite3', platform: :mri
  gem 'activerecord-jdbcsqlite3-adapter',
      git: 'https://github.com/jruby/activerecord-jdbc-adapter',
      branch: 'rails-5',
      platform: :jruby
end

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :active_admin_comments, force: true do |_t|
  end

  create_table :users, force: true do |t|
    t.string :full_name
  end
end

require 'action_controller/railtie'
require 'action_view/railtie'
require 'active_admin'

class TestApp < Rails::Application
  config.root = __dir__
  config.session_store :cookie_store, key: "cookie_store_key"
  secrets.secret_token = 'secret_token'
  secrets.secret_key_base = 'secret_key_base'

  config.eager_load = false
  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger
end

class ApplicationController < ActionController::Base
  include Rails.application.routes.url_helpers
end

class User < ActiveRecord::Base
end

ActiveAdmin.setup do |config|
  # Authentication disabled by default. Override if necessary.
  config.authentication_method = false
  config.current_user_method = false
end

Rails.application.initialize!

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }
  content do
    'Test Me'
  end
end

ActiveAdmin.register User do
end

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
end

require 'minitest/autorun'
require 'rack/test'
require 'rails/test_help'

# Replace this with the code necessary to make your test fail.
class BugTest < ActionDispatch::IntegrationTest

  def test_admin_root_success?
    get admin_root_url
    assert_response :success
    assert_match 'Test Me', response.body # has content
    assert_match 'Users', response.body # has 'Your Models' in menu
  end

  def test_admin_users
    User.create! full_name: 'John Doe'
    get admin_users_url
    assert_response :success
    assert_match 'John Doe', response.body # has created row
  end

  private

  def app
    Rails.application
  end
end
