# frozen_string_literal: true

module DecoratorHelpers
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
end
