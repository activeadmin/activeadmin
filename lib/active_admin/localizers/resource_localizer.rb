module ActiveAdmin
  module Localizers
    class ResourceLocalizer
      class << self
        def from_resource(resource_config)
          new(resource_config.resource_name.i18n_key, resource_config.resource_label)
        end

        def translate(key, options)
          new(options.delete(:model_name), options.delete(:model)).translate(key, options)
        end
        alias_method :t, :translate
      end

      def initialize(model_name, model = nil)
        @model_name = model_name
        @model = model || model_name.to_s.titleize
      end

      def translate(key, options = {})
        scope = options.delete(:scope)
        specific_key = array_to_key("resources", @model_name, scope, key)
        defaults = [array_to_key(scope, key), key.to_s.titleize]
        ::I18n.t specific_key, **options.reverse_merge(model: @model, default: defaults, scope: "active_admin")
      end
      alias_method :t, :translate

      protected

      def array_to_key(*arr)
        arr.flatten.compact.join(".").to_sym
      end
    end
  end
end
