require 'kaminari/models/active_record_extension'

module ActiveAdmin

  # manually initialize kaminari for this model
  ::ActiveRecord::Base.send :include, Kaminari::ActiveRecordExtension

  class Comment < ActiveRecord::Base
    self.table_name = "active_admin_comments"

    belongs_to :resource, :polymorphic => true
    belongs_to :author, :polymorphic => true

    validates_presence_of :resource
    validates_presence_of :body
    validates_presence_of :namespace

    # @returns [String] The name of the record to use for the polymorphic relationship
    def self.resource_type(record)
      record.class.base_class.name.to_s
    end

    def self.find_for_resource_in_namespace(resource, namespace)
      where(:resource_type => resource_type(resource),
            :resource_id => resource.id, 
            :namespace => namespace.to_s)
    end

  end

end

