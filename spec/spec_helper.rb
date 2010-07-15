$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
Bundler.setup

ENV['RAILS'] ||= '3.0.0'
ENV['RAILS_ENV'] = 'test'

if ENV['RAILS'] == '3.0.0'
  ENV['RAILS_ROOT'] = File.expand_path('../rails/rails-3.0.0', __FILE__)

  # Create the test app if it doesn't exists
  unless File.exists?(ENV['RAILS_ROOT'])
    system 'rake setup'  
  end

  require ENV['RAILS_ROOT'] + '/config/environment'
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
end

# Require Active Admin after we load the app env
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_admin'


module ActiveAdminIntegrationSpecHelper
  def self.included(klass)
    Rails.application.routes.draw do |map|
      namespace :admin do
        resources :posts
      end
    end
  end

  ActiveAdmin.register Post

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
