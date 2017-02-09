begin
  require 'bundler/inline'
rescue LoadError => e
  $stderr.puts 'Bundler version 1.10 or later is required. Please update your Bundler'
  raise e
end

gemfile(true) do
  source 'https://rubygems.org'

  gem 'rails'
  gem 'arel'
  gem 'sqlite3'
  gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin', require: false
  gem 'arbre',               '~> 1.0', '>= 1.0.2', require: false
  gem 'bourbon'
  gem 'coffee-rails'
  gem 'formtastic',          '~> 3.1'
  gem 'formtastic_i18n'
  gem 'inherited_resources', '~> 1.7', git: 'https://github.com/activeadmin/inherited_resources', require: false
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'kaminari',            '>= 0.15', '< 2.0'
  gem 'railties',            '>= 3.2', '< 5.1'
  gem 'ransack',             '1.3'
  gem 'sass-rails'
  gem 'sprockets',           '< 4.1'
end

require 'rails'
require 'active_record'
require 'action_controller'
require 'inherited_resources'
require 'logger'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :active_admin_comments, force: true do |t|
  end

  # Add your schema here
  create_table :your_model, force: true do |t|
  end
end


class ApplicationController < ActionController::Base; end;

# Trying to figure out how to include this automatically
module InheritedResources
  # = Base
  #
  # This is the base class that holds all actions. If you see the code for each
  # action, they are quite similar to Rails default scaffold.
  #
  # To change your base behavior, you can overwrite your actions and call super,
  # call <tt>default</tt> class method, call <<tt>actions</tt> class method
  # or overwrite some helpers in the base_helpers.rb file.
  #
  class Base < ::ApplicationController
    # Overwrite inherit_resources to add specific InheritedResources behavior.
    def self.inherit_resources(base)
      base.class_eval do
        include InheritedResources::Actions
        include InheritedResources::BaseHelpers
        extend  InheritedResources::ClassMethods
        extend  InheritedResources::UrlHelpers

        # Add at least :html mime type
        respond_to :html if self.mimes_for_respond_to.empty?
        self.responder = InheritedResources::Responder

        helper_method :resource, :collection, :resource_class, :association_chain,
                      :resource_instance_name, :resource_collection_name,
                      :resource_url, :resource_path,
                      :collection_url, :collection_path,
                      :new_resource_url, :new_resource_path,
                      :edit_resource_url, :edit_resource_path,
                      :parent_url, :parent_path,
                      :smart_resource_url, :smart_collection_url

        self.class_attribute :resource_class, :instance_writer => false unless self.respond_to? :resource_class
        self.class_attribute :parents_symbols,  :resources_configuration, :instance_writer => false

        protected :resource_class, :parents_symbols, :resources_configuration,
          :resource_class?, :parents_symbols?, :resources_configuration?
      end
    end

    inherit_resources(self)
  end
end

require 'activeadmin'

class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

  secrets.secret_token    = 'secret_token'
  secrets.secret_key_base = 'secret_key_base'

  # Define any models required to duplicate your issue
  class YourModel < ActiveRecord::Base; end;

  # Define any ActiveAdmin configuration necessary to duplicate your issue
  ActiveAdmin.setup do |config|
    # Authentication disabled by default. Override if necessary
    config.authentication_method = false
    config.current_user_method   = false
  end

  ActiveAdmin.register_page 'Dashboard' do
    content do
      'Test Me'
    end
  end

  # Set up your models as you have them in your ActiveAdmin config
  ActiveAdmin.register YourModel do
  end

  routes.draw do
    ActiveAdmin.routes(self)
  end
end

require 'minitest/autorun'
require 'rack/test'

# Replace this with the code necessary to make your test fail.
class BugTest < Minitest::Test
  include Rack::Test::Methods

  def test_returns_success?
    get '/admin'
    assert last_response.ok?
  end

  private

  def app
    Rails.application
  end
end
