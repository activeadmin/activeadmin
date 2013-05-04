module ActiveAdmin
  class BaseController < ::InheritedResources::Base
    module Translation

      def self.included(c)
        c.helper_method :translation_per_model
      end

      protected

      def translation_per_model(resource_class, action, model_label)
        I18n.t "active_admin.#{resource_class.to_s.downcase}.#{action.to_s}_model", 
          :model => model_label, 
          :default => proc { I18n.t "active_admin.#{action.to_s}_model", :model => model_label }
      end
    end
  end
end
