module ActiveAdmin

  #
  # The Active Admin DSL. This class is where all the registration blocks
  # are instance eval'd. This is the central place for the API given to 
  # users of Active Admin
  #
  class DSL

    # Runs the registration block inside this object
    def run_registration_block(config, &block)
      @config = config
      instance_eval &block
    end

    private

    # The instance of ActiveAdmin::Config that's being registered
    # currently. You can use this within your registration blocks to
    # modify options:
    #
    # eg:
    # 
    #   ActiveAdmin.register Post do
    #     config.sort_order = "id_desc"
    #   end
    #
    def config
      @config
    end

    # Returns the controller for this resource. If you pass a
    # block, it will be eval'd in the controller
    #
    # Example:
    #
    #   ActiveAdmin.register Post do
    #
    #     controller do
    #       def some_method_on_controller
    #         # Method gets added to Admin::PostsController
    #       end
    #     end
    #
    #   end
    #
    def controller(&block)
      @config.controller.class_eval(&block) if block_given?
      @config.controller
    end

    # Add a new action item to the resource
    #
    # @param [Hash] options valid keys include:
    #                 :only:  A single or array of controller actions to display
    #                         this action item on.
    #                 :except: A single or array of controller actions not to
    #                          display this action item on.
    def action_item(options = {}, &block)
      config.add_action_item(options, &block)
    end

    def menu(options = {})
      config.menu(options)
    end

    def sidebar(name, options = {}, &block)
      config.sidebar_sections << ActiveAdmin::SidebarSection.new(name, options, &block)
    end
  end
end
