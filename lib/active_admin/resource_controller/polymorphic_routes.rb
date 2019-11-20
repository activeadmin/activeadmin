require "active_admin/resource"
require "active_admin/resource/model"

module ActiveAdmin
  class ResourceController < BaseController
    module PolymorphicRoutes
      def polymorphic_url(record_or_hash_or_array, options = {})
        super(map_named_resources_for(record_or_hash_or_array), options)
      end

      def polymorphic_path(record_or_hash_or_array, options = {})
        super(map_named_resources_for(record_or_hash_or_array), options)
      end

      private

      def map_named_resources_for(record_or_hash_or_array)
        return record_or_hash_or_array unless record_or_hash_or_array.is_a?(Array)

        record_or_hash_or_array.map { |record| to_named_resource(record) }
      end

      def to_named_resource(record)
        if record.is_a?(resource_class)
          return ActiveAdmin::Model.new(active_admin_config, record)
        end

        belongs_to_resource = active_admin_config.belongs_to_config.try(:resource)
        if belongs_to_resource && record.is_a?(belongs_to_resource.resource_class)
          return ActiveAdmin::Model.new(belongs_to_resource, record)
        end

        record
      end
    end
  end
end
