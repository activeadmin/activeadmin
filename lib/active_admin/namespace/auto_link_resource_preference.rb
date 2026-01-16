# frozen_string_literal: true

module ActiveAdmin
  module AutoLinkResourcePreference
    def resource_for(klass)
      return super unless valid_class_for_processing?(klass)

      candidates = find_resource_candidates(klass)
      return super if candidates.size <= 1

      find_canonical_resource(candidates) || super
    end

    private

    def valid_class_for_processing?(klass)
      klass.is_a?(Class) && klass.respond_to?(:model_name)
    end

    def find_resource_candidates(klass)
      table_name = extract_table_name(klass)
      return [] if table_name.blank?

      resources.values.select do |resource|
        resource_matches_table?(resource, table_name)
      end
    end

    def extract_table_name(klass)
      klass.respond_to?(:table_name) ? klass.table_name : nil
    end

    def resource_matches_table?(resource, table_name)
      return false unless resource.is_a?(::ActiveAdmin::Resource)
      return false unless resource.resource_class.respond_to?(:table_name)

      resource.resource_class.table_name == table_name
    end

    def find_canonical_resource(candidates)
      candidates.find do |resource|
        resource.resource_name.route_key == resource.resource_class.model_name.route_key
      end
    end
  end
end

ActiveAdmin::Namespace.prepend(ActiveAdmin::AutoLinkResourcePreference)
