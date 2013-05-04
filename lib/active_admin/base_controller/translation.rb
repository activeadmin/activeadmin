module ActiveAdmin
  module Inputs
    class FilterStringInput

      protected

      def translation_per_search_field(field)
        t_per_field = I18n.t("active_admin.search_field.#{field.to_s.gsub(/ /,'_').downcase}", :field => field, :default => "")
        unless t_per_field.blank?
          return t_per_field
        else
          return I18n.t('active_admin.search_field', :field => field)
        end            
      end

    end
  end
end
