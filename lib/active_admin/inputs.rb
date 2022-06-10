# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DatepickerInput
    autoload :RichTextAreaInput

    module Filters
      extend ActiveSupport::Autoload

      autoload :Base
      autoload :StringInput
      autoload :TextInput
      autoload :DatePickerInput
      autoload :DateRangeInput
      autoload :NumericInput
      autoload :SelectInput
      autoload :CheckBoxesInput
      autoload :BooleanInput
    end
  end
end
