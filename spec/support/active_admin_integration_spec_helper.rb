module ActiveAdminIntegrationSpecHelper
  def with_resources_during(example)
    load_resources { yield }

    example.run

    load_resources {}
  end

  def reload_menus!
    ActiveAdmin.application.namespaces.each { |n| n.reset_menu! }
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
  #     ActiveAdmin.register(Post)
  #   end
  #
  def load_resources
    ActiveAdmin.unload!
    yield
    reload_menus!
    reload_routes!
  end

  def arbre(assigns = {}, helpers = mock_action_view, &block)
    Arbre::Context.new(assigns, helpers, &block)
  end

  def render_arbre_component(assigns = {}, helpers = mock_action_view, &block)
    arbre(assigns, helpers, &block).children.first
  end

  # A mock action view to test view helpers
  class MockActionView < ::ActionView::Base
    include ActiveAdmin::ViewHelpers
    include Rails.application.routes.url_helpers
  end

  # Returns a fake action view instance to use with our renderers
  def mock_action_view(base = MockActionView)
    controller = ActionView::TestCase::TestController.new

    base.new(view_paths, {}, controller)
  end

  # Instantiates a fake decorated controller ready to unit test for a specific action
  def controller_with_decorator(action, decorator_class)
    method = action == "index" ? :apply_collection_decorator : :apply_decorator

    controller_class = Class.new do
      include ActiveAdmin::ResourceController::Decorators

      public method
    end

    active_admin_config = double(decorator_class: decorator_class)

    if action != "index"
      form_presenter = double(options: { decorate: !decorator_class.nil? })

      allow(active_admin_config).to receive(:get_page_presenter).with(:form).and_return(form_presenter)
    end

    controller = controller_class.new

    allow(controller).to receive(:active_admin_config).and_return(active_admin_config)
    allow(controller).to receive(:action_name).and_return(action)

    controller
  end

  def view_paths
    paths = ActionController::Base.view_paths
    # the constructor for ActionView::Base changed from Rails 6
    # and now expects an instance of ActionView::LookupContext
    return paths unless Rails::VERSION::MAJOR >= 6
    ActionView::LookupContext.new(paths)
  end

  def with_translation(translation)
    # If no translations have been loaded, any later calls to `I18n.t` will
    # cause the full translation hash to be loaded, possibly overwritting what
    # we've loaded via `store_translations`. We use this hack to prevent that.
    I18n.backend.send(:init_translations)
    I18n.backend.store_translations I18n.locale, translation
    yield
  ensure
    I18n.backend.reload!
  end
end
