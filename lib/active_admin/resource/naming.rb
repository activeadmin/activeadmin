module ActiveAdmin
  class Resource
    module Naming

      def resource_name
        custom_name = @options[:as] && @options[:as].gsub(/\s/,'')
        @resource_name ||= if custom_name || !resource_class.respond_to?(:model_name)
            ActiveModel::Name.new(resource_class, nil, custom_name)
          else
            resource_class.model_name
          end
      end

      # Returns the name to call this resource such as "Bank Account"
      def resource_label
        if @options[:as]
          @options[:as]
        else
           (@resource_label ||= {})[::I18n.locale] ||= resource_name.human(:default => resource_name.gsub('::', ' ')).titleize
         end
      end

      # Returns the plural version of this resource such as "Bank Accounts"
      def plural_resource_label
        if @options[:as]
          @options[:as].pluralize
        else
          (@plural_resource_label ||= {})[::I18n.locale] ||= resource_name.human(:count => 3, :default => resource_label.pluralize).titleize
        end
      end

      # A name used internally to uniquely identify this resource
      def resource_key
        resource_name
      end
    end
  end
end
