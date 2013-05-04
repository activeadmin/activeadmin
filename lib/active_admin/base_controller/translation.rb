module ActiveAdmin
  module Inputs
    class FilterStringInput

      protected

      def translation_per_search_field(field)
        t_per_field = I18n.t("active_admin.search_fields.#{field.to_s.gsub(/ /,'_').downcase}", :field => field, :default => "")
        unless t_per_field.blank?
          return t_per_field
        else
          return I18n.t('active_admin.search_field', :field => field)
        end            
      end
    end
  end
  
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
