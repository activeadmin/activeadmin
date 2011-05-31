# Support for CanCan within Active Admin

module ActiveAdmin
  module CanCan
    if defined?(::CanCan)

      class ControllerResource < ::CanCan::InheritedResource
        def resource_base
          @controller.send :collection
        end
      end

      module ControllerAdditions
        def cancan_resource_class
          ::ActiveAdmin::CanCan::ControllerResource
        end
      end

      ActiveAdmin::ResourceController.send :include, ControllerAdditions
    end
  end
end
