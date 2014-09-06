module ActiveAdmin
  module ViewHelpers
    module ColumnsHelper

      def columns(&block)
        @columns ||= ActiveAdmin::Views::Columns.new
        @columns.columns do
          content_tag(:div, &block) if block_given?
        end
      end

      def column(options = {}, &block)
        @columns ||= ActiveAdmin::Views::Columns.new
        @columns.column options do
          content_tag(:div, &block) if block_given?
        end
      end

    end
  end
end
