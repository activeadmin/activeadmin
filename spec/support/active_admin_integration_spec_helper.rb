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
