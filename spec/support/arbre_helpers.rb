# frozen_string_literal: true

module ArbreHelpers
  def render_arbre_component(assigns = {}, helpers = mock_action_view, &block)
    Arbre::Context.new(assigns, helpers, &block).children.first
  end

  # Helpers available to the mock action view used to test view helpers
  module MockActionViewHelpers
    include ActiveAdmin::LayoutHelper
    include ActiveAdmin::AutoLinkHelper
    include ActiveAdmin::DisplayHelper
    include ActiveAdmin::IndexHelper
    include MethodOrProcHelper
  end

  # Returns a fake action view instance to use with our renderers.
  #
  # Rails compiles each template once, into the shared view class that all
  # real views inherit from. The mock must inherit from that same class:
  # otherwise a template first rendered by a real request (e.g. in a system
  # spec) is missing here, and one first rendered here is missing from the
  # next real request.
  def mock_action_view
    view_class = Class.new(ActionView::LookupContext::DetailsKey.view_context_class) do
      include MockActionViewHelpers
      # Included here rather than in the module: its `included` hook sets up
      # default_url_options on the including class.
      include Rails.application.routes.url_helpers
    end
    controller = ActionView::TestCase::TestController.new

    lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
    view_class.new(lookup_context, {}, controller)
  end
end
