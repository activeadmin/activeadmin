# frozen_string_literal: true
module ActiveAdmin

  class Resource
    module Pagination

      # The default number of records to display per page
      attr_accessor :per_page

      # The default number of records to display per page
      attr_accessor :max_per_page

      # Enable / disable pagination (defaults to true)
      attr_writer :paginate

      def initialize(*args)
        super
        @paginate = true
        @per_page = namespace.default_per_page
        @max_per_page = namespace.max_per_page
      end

      def paginate(controller: nil)
        if @paginate.is_a?(Proc)
          controller ? controller.instance_eval(&@paginate) : @paginate.call
        else
          @paginate
        end
      end
    end
  end
end
