module ActiveAdmin
  class Resource < Config
    module Naming
      # Returns the name to call this resource.
      def resource_name
        @resource_name ||= @options[:as]
        @resource_name ||= singular_human_name
        @resource_name ||= resource.name.gsub('::',' ')
      end

      # Returns the plural version of this resource
      def plural_resource_name
        @plural_resource_name ||= @options[:as].pluralize if @options[:as]
        @plural_resource_name ||= plural_human_name
        @plural_resource_name ||= resource_name.pluralize
      end

      private

      # @return [String] Human name via ActiveRecord I18n or nil
      def singular_human_name
        return nil unless resource.respond_to?(:model_name)
        resource.model_name.human
      end

      # @return [String] Plural human name via ActiveRecord I18n or nil
      def plural_human_name
        return nil unless resource.respond_to?(:model_name)
        begin
          I18n.translate!("activerecord.models.#{resource.model_name.i18n_key}")
          resource.model_name.human(:count => 3)
        rescue I18n::MissingTranslationData
          nil
        end
      end
    end
  end
end
