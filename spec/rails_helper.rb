require 'spec_helper'

module ActiveAdminIntegrationSpecHelper
  extend self

  def load_defaults!
    ActiveAdmin.unload!
    ActiveAdmin.load!
    ActiveAdmin.register(Category)
    ActiveAdmin.register(User)
    ActiveAdmin.register(Post){ belongs_to :user, optional: true }
    reload_menus!
  end

  def reload_menus!
    ActiveAdmin.application.namespaces.each{|n| n.reset_menu! }
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

  def with_translation(translation)
    I18n.backend.store_translations :en, translation
    yield
  ensure
    I18n.backend.reload!
  end

end

require 'rails'
require 'active_record'
require 'active_admin'
require 'devise'

# NOTE: Safe to use fuzzy rails version here?  Or does it need to be exact?
#       Fuzzy *should* be OK.
fuzzy_rails_version = "#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}.x"
ENV["RAILS_ENV"] = "test"
ENV["RAILS_ROOT"] = File.expand_path("../rails/ruby-#{RUBY_VERSION}-rails-#{fuzzy_rails_version}", __FILE__)
puts "[rails_helper.rb] Rails Root: #{ENV["RAILS_ROOT"]}"

# Create the test app if it doesn't exists
unless File.exists?(ENV["RAILS_ROOT"])
  puts "[rails_helper.rb] BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec rake setup"
  system %[BUNDLE_GEMFILE='gemfiles/Gemfile.rails-#{fuzzy_rails_version}' bundle exec rake setup]
else
  puts "already setup #{ENV["RAILS_ROOT"]}"
end

ActiveAdmin.application.load_paths = [ENV["RAILS_ROOT"] + "/app/admin"]

require ENV["RAILS_ROOT"] + '/config/environment'

require 'rspec/rails'

# Prevent Test::Unit's AutoRunner from executing during RSpec's rake task on
# JRuby
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)

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
  config.include Devise::TestHelpers, type: :controller
  config.render_views = false
  config.filter_run focus: true
  config.filter_run_excluding skip: true
  config.run_all_when_everything_filtered = true
end

# All RSpec configuration needs to happen before any examples
# or else it whines.
require "support/active_admin_request_helpers"
RSpec.configure do |c|
  c.include ActiveAdminRequestHelpers, type: :request
  c.include Devise::TestHelpers, type: :controller
end

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = 4

# Improves performance by forcing the garbage collector to run less often.
unless ENV['DEFER_GC'] == '0' || ENV['DEFER_GC'] == 'false'
  require 'support/deferred_garbage_collection'
  RSpec.configure do |config|
    config.before(:all) { DeferredGarbageCollection.start }
    config.after(:all)  { DeferredGarbageCollection.reconsider }
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end
