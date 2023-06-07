# frozen_string_literal: true
module ActiveAdmin
  class Resource
    module Ordering

      def ordering
        @ordering ||= {}.with_indifferent_access
      end

    end
  end
end
