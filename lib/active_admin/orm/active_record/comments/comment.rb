# frozen_string_literal: true
module ActiveAdmin
  class Comment < ActiveRecord::Base

    self.table_name = "#{table_name_prefix}active_admin_comments#{table_name_suffix}"

    belongs_to :resource, polymorphic: true, optional: true
    belongs_to :author, polymorphic: true, optional: true

    validates_presence_of :body, :namespace, :resource
    validates_presence_of :author, if: -> { Rails.application.config.active_record.belongs_to_required_by_default && ActiveAdmin.application.authentication_method != false }

    before_create :set_resource_type

    # @return [String] The name of the record to use for the polymorphic relationship
    def self.resource_type(resource)
      ResourceController::Decorators.undecorate(resource).class.base_class.name.to_s
    end

    def self.find_for_resource_in_namespace(resource, namespace)
      where(
        resource_type: resource_type(resource),
        resource_id: resource.id,
        namespace: namespace.to_s
      ).order(ActiveAdmin.application.namespaces[namespace.to_sym].comments_order)
    end

    def set_resource_type
      self.resource_type = self.class.resource_type(resource)
    end

  end
end
