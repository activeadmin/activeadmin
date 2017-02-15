module ActiveAdmin
  module Inputs
    extend ActiveSupport::Autoload

    autoload :DatepickerInput

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
