# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class NumericInput < ::Formtastic::Inputs::NumberInput
        include Base
        include Base::SearchMethodSelect

        filter :eq, :gt, :lt
      end
    end
  end
end
