module ActiveAdmin
  module Inputs
    class FilterNumericInput < ::Formtastic::Inputs::NumberInput
      include FilterBase
      include FilterBase::SearchMethodSelect

      filter :equals, :greater_than, :less_than
    end
  end
end
