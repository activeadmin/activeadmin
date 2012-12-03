module ActiveAdmin
  class ResourceController < BaseController
    module InheritedResourcesOverrides

      # Override the default resource_class class and instance
      # methods to only return the class defined in the instance
      # of ActiveAdmin::Resource
      def override_inherited_resources_methods!
        self.class_eval do          
          class << self
            # set by DSL
            attr_accessor :params_to_permit
          end

          def self.resource_class=(klass); end

          def self.resource_class
            @active_admin_config ? @active_admin_config.resource_class : nil
          end

          def resource_class
            self.class.resource_class
          end

          def resource_params
            return [] if request.get? || !params[self.class.resource_class.name.underscore.to_sym]
            if active_admin_config.namespace.application.enforce_strong_parameters || (self.class.params_to_permit && self.class.params_to_permit.size > 0)
              # hack because couldn't get SP to work properly
              [ params[self.class.resource_class.name.underscore.to_sym].permit!.reject{|k,v|!self.class.params_to_permit.include?(k.to_sym)} ]
            else
              [ params[self.class.resource_class.name.underscore.to_sym].permit! ]
            end
          end
        end
      end
    end
  end
end
