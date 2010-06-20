$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
TEST_RAILS_VERSION = ENV['RAILS'] || '3.0.0'
RAILS_ENV = ENV['RAILS_ENV'] = 'test'

if TEST_RAILS_VERSION == '3.0.0'
  # Rails 3
  RAILS_ROOT = File.expand_path('../rails/rails-3.0.0', __FILE__)
  ENV['BUNDLE_GEMFILE'] = File.join(RAILS_ROOT, 'Gemfile')
  require RAILS_ROOT + '/config/environment'
  require 'rspec/rails'

  Rspec.configure do |config|
    config.use_transactional_fixtures = true
    config.use_instantiated_fixtures = false
  end

  Rspec::Matchers.define :have_tag do |*args|
    match_unless_raises Test::Unit::AssertionFailedError do |response|
      tag = args.shift
      content = args.first.is_a?(Hash) ? nil : args.shift
      
      options = {
        :tag => tag
      }.merge(args[0] || {})
      
      options[:content] = content if content
      assert_tag(options)
    end
  end
else
  # Rails 2.3.5
  RAILS_ROOT = File.expand_path('../rails/rails-2.3.5', __FILE__)
  require RAILS_ROOT + '/config/environment'
  require 'spec/rails'
  require 'spec/autorun'  
  Spec::Runner.configure do |config|

  end
end

# Require Active Admin after we load the app env
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_admin'


module ActiveAdminIntegrationSpecHelper
  def self.included(klass)
    ActionController::Routing::Routes.draw do |map|
      map.namespace :admin do |admin|
        admin.resources :posts
      end
    end
  end
  module ::Admin
    class PostsController < ::ActiveAdmin::AdminController
    end
  end

  # Returns a fake action view instance to use with our renderers
  def action_view(assigns = {})
    controller = ActionView::TestCase::TestController.new
    ActionView::Base.send :include, ActionView::Helpers
    ActionView::Base.send :include, ActiveAdmin::ViewHelpers
    view = ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
    view._router = controller._router
    view
  end  
end
