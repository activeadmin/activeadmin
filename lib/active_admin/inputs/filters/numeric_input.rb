# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class NumericInput < ::Formtastic::Inputs::NumberInput
        include Base
        include Base::SearchMethodSelect

        filter :equals, :greater_than, :less_than
      end
    end
  end
end
