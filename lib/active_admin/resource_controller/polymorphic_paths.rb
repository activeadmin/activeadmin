# If we rename a resource by calling `ActiveAdmin.register Model, as: RenamedModel`,
# ActiveAdmin creates a #admin_renamed_model_path helper method.
# If we also use belongs_to inside the ActiveAdmin.register block,
# InheritedResources will call the #polymorphic_path method
# and pass "resource_class.new" as an argument.
# #resource_class is the original model class, and it doesn't know
# anything about the renamed ActiveAdmin resource.
# So when #polymorphic_path calls #model_name on the class, it returns
# the original model name (e.g. "Model", instead of "RenamedModel")
# and will end up calling #admin_model_path, instead of #admin_renamed_model_path.
# This causes an error, because #admin_model_path is not defined.
#
# This issue was solved by overriding #polymorphic_path and #polymorphic_url.
# We monkey-patch #model_name for any instances of #resource_class, and
# return ActiveAdmin's #resource_name instead.

module ActiveAdmin
  class ResourceController < BaseController
    module PolymorphicPaths
      extend ActiveSupport::Concern

      protected

      def polymorphic_path(record_or_hash_or_array, options = {})
        return super unless record_or_hash_or_array.is_a?(Array)
        super(
          polymorphic_args_with_patched_model_name(record_or_hash_or_array),
          options)
      end

      def polymorphic_url(record_or_hash_or_array, options = {})
        return super unless record_or_hash_or_array.is_a?(Array)
        super(
          polymorphic_args_with_patched_model_name(record_or_hash_or_array),
          options)
      end

      def polymorphic_args_with_patched_model_name(array)
        @_patched_polymorphic_resources ||= {}
        array.map do |item|
          next item unless item.is_a?(resource_class)
          @_patched_polymorphic_resources[item.object_id] ||= item.tap do |i|
            i.class_eval { attr_accessor :model_name }
            i.model_name = active_admin_config.resource_name
          end
        end
      end
    end
  end
end
