# frozen_string_literal: true
module ActiveAdmin
  module Views
    # = Columns Component
    #
    # This is deprecated.
    #
    # The Columns component allows you draw content into scalable columns
    # using CSS Grid.
    #
    # To create a two column layout:
    #
    #     columns do
    #       column do
    #         span "Column # 1"
    #       end
    #       column do
    #         span "Column # 2"
    #       end
    #     end
    #
    # Apply Tailwind utilities to either the columns or column component to
    # set additional or override base styles.
    class Columns < ActiveAdmin::Component
      builder_method :columns

      def build(*args)
        super
        add_class default_class_name
      end

      def column(*args, &block)
        insert_tag Arbre::HTML::Div, *args, &block
      end
    end
  end
end
