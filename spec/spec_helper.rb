$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)

require 'rubygems'
require "bundler"
Bundler.setup

# Setup autoloading of ActiveAdmin and the load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
autoload :ActiveAdmin, 'active_admin'

module ActiveAdminIntegrationSpecHelper

  def self.load!
    ActiveAdmin.register Post
    ActiveAdmin.register Category
  end

  # Sometimes we need to reload the routes within
  # the application to test them out
  def reload_routes!
    Rails.application.reload_routes!
  end

  # Sets up a describe block where you can render controller 
  # actions. Uses the Admin::PostsController as the subject
  # for the describe block
  def describe_with_render(*args, &block)
    describe *args do
      include RSpec::Rails::ControllerExampleGroup
      render_views  
      metadata[:behaviour][:describes] = Admin::PostsController
      module_eval &block
    end
  end

  # Returns a fake action view instance to use with our renderers
  def action_view(assigns = {})
    controller = ActionView::TestCase::TestController.new
    ActionView::Base.send :include, ActionView::Helpers
    ActionView::Base.send :include, ActiveAdmin::ViewHelpers
    ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
  end  

end

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

  # Setup Some Admin stuff for us to play with
  ActiveAdminIntegrationSpecHelper.load!
  include ActiveAdminIntegrationSpecHelper

  # Force the routes to be reloaded
  Rails.application.reload_routes!

  # Don't add asset cache timestamps. Makes it easy to integration
  # test for the presence of an asset file
  ENV["RAILS_ASSET_ID"] = ''

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


