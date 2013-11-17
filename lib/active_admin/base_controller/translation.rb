module ActiveAdmin
  module Inputs
    class FilterStringInput

      protected

      def translation_per_search_field(field)
        t_per_field = I18n.t("active_admin.search_fields.#{field.to_s.gsub(/ /,'_').downcase}", :field => field, :default => "")
        unless t_per_field.blank?
          return t_per_field
        else
          return field
        end            
      end
    end
  end
  
  class BaseController < ::InheritedResources::Base
    module Translation

      def self.included(c)
        c.helper_method :translation_per_model
      end

      protected

      def translation_per_model(resource_class, action, model_label)
        I18n.t "active_admin.#{resource_class.to_s.downcase}.#{action.to_s}_model", 
          model: model_label, 
          default: proc { I18n.t "active_admin.#{action.to_s}_model", :model => model_label }
      end
    end
  end
end
