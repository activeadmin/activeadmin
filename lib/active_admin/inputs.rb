# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    extend ActiveSupport::Autoload

    module Filters
      extend ActiveSupport::Autoload

      autoload :Base
      autoload :StringInput
      autoload :TextInput
      autoload :DateRangeInput
      autoload :NumericInput
      autoload :SelectInput
      autoload :CheckBoxesInput
      autoload :BooleanInput
    end
  end
end
