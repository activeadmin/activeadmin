module ActiveAdmin
  class Resource
    module Includes

      # Return an array of includes for this resource
      def includes
        @includes ||= []
      end

    end
  end
end
