# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class DatePickerInput < ::Formtastic::Inputs::DatePickerInput
        include Base

        def input_html_options
          super.merge(class: "datepicker")
        end
      end
    end
  end
end
