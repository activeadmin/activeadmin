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
  end

  # Sometimes we need to reload the routes within
  # the application to test them out
  def reload_routes!
    Rails::Application.routes_reloader.reload!
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

  # Force the routes to be reloaded
  Rails::Application.routes_reloader.reload!

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


