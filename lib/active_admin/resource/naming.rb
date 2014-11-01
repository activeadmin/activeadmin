module ActiveAdmin
  class Resource

    module Naming
      def resource_name
        @resource_name ||= begin
          as = @options[:as].gsub /\s/, '' if @options[:as]

          if as || !resource_class.respond_to?(:model_name)
            Name.new resource_class, as
          else
            Name.new resource_class
          end
        end
      end

      # Returns the name to call this resource such as "Bank Account"
      def resource_label
        resource_name.translate count: 1,
          default: resource_name.to_s.gsub('::', ' ').titleize
      end

      # Returns the plural version of this resource such as "Bank Accounts"
      def plural_resource_label(options = {})
        defaults = {count:   Helpers::I18n::PLURAL_MANY_COUNT,
                    default: resource_label.pluralize.titleize}
        resource_name.translate defaults.merge options
      end

      # Forms use the model's original `param_key`, so we can't use our
      # custom `resource_name` when the model's been renamed in ActiveAdmin.
      def param_key
        if resource_class.respond_to? :model_name
          resource_class.model_name.param_key
        else
          resource_name.param_key
        end
      end
    end

    class Name < ActiveModel::Name
      delegate :hash, to: :to_str

      def initialize(klass, name = nil)
        super(klass, nil, name)
      end

      def translate(options = {})
        I18n.t i18n_key, {scope: [:activerecord, :models]}.merge(options)
      end

      def route_key
        plural
      end

      def eql?(other)
        to_str.eql?(other.to_str)
      end
    end

  end
end
