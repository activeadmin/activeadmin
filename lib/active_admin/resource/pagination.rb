module ActiveAdmin

  class Resource
    module Pagination

      # The default number of records to display per page
      attr_accessor :per_page

      # Enable / disable pagination (defaults to true)
      attr_accessor :paginate

      # Export Behaviour
      attr_accessor :export_behaviour

      def initialize(*args)
        super
        @paginate = true
        @per_page = namespace.default_per_page
        @export_behaviour = namespace.export_behaviour
      end
    end
  end
end
