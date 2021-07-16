# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class NumericInput < ::Formtastic::Inputs::NumberInput
        include Base
        include Base::SearchMethodSelect

        filter :equals, :greater_than, :less_than

        def input_html
          builder.number_field current_filter, input_html_options
        end
      end
    end
  end
end
