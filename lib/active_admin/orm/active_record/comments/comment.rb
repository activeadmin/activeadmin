module ActiveAdmin
  class Comment < ActiveRecord::Base

    self.table_name = 'active_admin_comments'

    belongs_to :resource, polymorphic: true
    belongs_to :author,   polymorphic: true

    unless Rails::VERSION::MAJOR > 3 && !defined? ProtectedAttributes
      attr_accessible :resource, :resource_id, :resource_type, :body, :namespace
    end

    validates_presence_of :body, :namespace, :resource

    before_create :set_resource_type

    # @returns [String] The name of the record to use for the polymorphic relationship
    def self.resource_type(resource)
      undecorate_resource(resource).class.name.to_s
    end

    def self.undecorate_resource(resource)
      ActiveAdmin::ResourceController::Decorators.undecorate_resource(resource)
    end

    # Postgres adapters won't compare strings to numbers (issue 34)
    def self.resource_id_cast(record)
      resource_id_type == :string ? record.id.to_s : record.id
    end

    def self.find_for_resource_in_namespace(resource, namespace)
      where resource_type: resource_type(resource),
            resource_id:   resource_id_cast(resource),
            namespace:     namespace.to_s
    end

    def self.resource_id_type
      columns.detect{ |i| i.name == "resource_id" }.type
    end

    def set_resource_type
      self.resource_type = self.class.resource_type(resource)
    end

  end
end

