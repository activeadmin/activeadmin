module ActiveAdmin
  class BaseController < ::InheritedResources::Base
    module Translation
      extend ActiveSupport::Concern

      included do
        helper_method :translation_per_model
      end

      protected

      def translation_per_model(resource_class, action, model_label)
        t_per_model = I18n.t("active_admin.#{resource_class.to_s.downcase}.#{action}", :model => model_label, :default => "")
        unless t_per_model.blank?
          return t_per_model
        else
          return I18n.t("active_admin.#{action}", :model => model_label)
        end            
      end
    end
  end
end
