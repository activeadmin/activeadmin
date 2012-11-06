require File.expand_path("../spec_helper_without_rails", __FILE__)

module ActiveAdminIntegrationSpecHelper
  extend self

  def load_defaults!
    ActiveAdmin.unload!
    ActiveAdmin.load!
    ActiveAdmin.register(Category)
    ActiveAdmin.register(User)
    ActiveAdmin.register(Post){ belongs_to :user, :optional => true }
    reload_menus!
  end

  def reload_menus!
    ActiveAdmin.application.namespaces.values.each{|n| n.reset_menu! }
  end

  # Sometimes we need to reload the routes within
  # the application to test them out
  def reload_routes!
    Rails.application.reload_routes!
  end

  # Helper method to load resources and ensure that Active Admin is
  # setup with the new configurations.
  #
  # Eg:
  #   load_resources do
  #     ActiveAdmin.regiser(Post)
  #   end
  #
  def load_resources
    ActiveAdmin.unload!
    yield
    reload_menus!
    reload_routes!
  end

  # Sets up a describe block where you can render controller 
  # actions. Uses the Admin::PostsController as the subject
  # for the describe block
  def describe_with_render(*args, &block)
    describe *args do
      include RSpec::Rails::ControllerExampleGroup
      render_views  
      # metadata[:behaviour][:describes] = ActiveAdmin.namespaces[:admin].resources['Post'].controller
      module_eval &block
    end
  end

  def arbre(assigns = {}, helpers = mock_action_view, &block)
    Arbre::Context.new(assigns, helpers, &block)
  end

  def render_arbre_component(assigns = {}, helpers = mock_action_view, &block)
    arbre(assigns, helpers, &block).children.first
  end

  # Setup a describe block which uses capybara and rails integration
  # test methods.
  def describe_with_capybara(*args, &block)
    describe *args do
      include RSpec::Rails::IntegrationExampleGroup
      module_eval &block
    end
  end

  # Returns a fake action view instance to use with our renderers
  def mock_action_view(assigns = {})
    controller = ActionView::TestCase::TestController.new
    ActionView::Base.send :include, ActionView::Helpers
    ActionView::Base.send :include, ActiveAdmin::ViewHelpers
    ActionView::Base.send :include, Rails.application.routes.url_helpers
    ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
  end  
  alias_method :action_view, :mock_action_view

  # A mock resource to register
  class MockResource
  end

end

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] = File.expand_path("../rails/rails-#{ENV['RAILS']}", __FILE__)

# Create the test app if it doesn't exists
unless File.exists?(ENV['RAILS_ROOT'])
  system 'rake setup'
end

# Ensure the Active Admin load path is happy
require 'rails'
require 'active_admin'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]

require ENV['RAILS_ROOT'] + '/config/environment'

require 'rspec/rails'

# Setup Some Admin stuff for us to play with
include ActiveAdminIntegrationSpecHelper
load_defaults!
reload_routes!

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

# Don't add asset cache timestamps. Makes it easy to integration
# test for the presence of an asset file
ENV["RAILS_ASSET_ID"] = ''

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.include Devise::TestHelpers, :type => :controller
  config.render_views = false
end

# All RSpec configuration needs to happen before any examples
# or else it whines.
require 'integration_example_group'
RSpec.configure do |c|
  c.include RSpec::Rails::IntegrationExampleGroup, :example_group => { :file_path => /\bspec\/integration\// }
  c.include Devise::TestHelpers, :type => :controller
end

# Ensure this is defined for Ruby 1.8
module MiniTest; class Assertion < Exception; end; end

RSpec::Matchers.define :have_tag do |*args|

  match_unless_raises Test::Unit::AssertionFailedError do |response|
    tag = args.shift
    content = args.first.is_a?(Hash) ? nil : args.shift
    
    options = {
      :tag => tag.to_s
    }.merge(args[0] || {})
    
    options[:content] = content if content

    begin
      begin
        assert_tag(options)
      rescue NoMethodError
        # We are not in a controller, so let's do the checking ourselves
        doc = HTML::Document.new(response, false, false)
        tag = doc.find(options)
        assert tag, "expected tag, but no tag found matching #{options.inspect} in:\n#{response.inspect}"
      end
    # In Ruby 1.9, MiniTest::Assertion get's raised, so we'll
    # handle raising a Test::Unit::AssertionFailedError
    rescue MiniTest::Assertion => e
      raise Test::Unit::AssertionFailedError, e.message
    end
  end
end

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = 4
