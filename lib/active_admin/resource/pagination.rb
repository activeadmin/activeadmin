module ActiveAdmin

  class Resource
    module Pagination

      # The default number of records to display per page
      attr_accessor :per_page

      # Enable / disable pagination (defaults to true)
      attr_accessor :paginate

      def initialize(*args)
        super
        @paginate = true
        if self.resource_class.respond_to?(:default_per_page) 
          @per_page =  self.resource_class.default_per_page
        end
         if @per_page.nil? || @per_page == 0
           @per_page = namespace.default_per_page
         end
      end
    end
  end
end
