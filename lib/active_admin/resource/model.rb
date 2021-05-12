# frozen_string_literal: true
module ActiveAdmin
  class Model
    def initialize(resource, record)
      @record = record

      if resource
        @record.extend(resource.resource_name_extension)
      end
    end

    def to_model
      @record
    end
  end
end
