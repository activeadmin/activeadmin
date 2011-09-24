module ActiveAdmin
  module Inputs
    class FilterCheckBoxesInput < ::Formtastic::Inputs::CheckBoxesInput
      include FilterBase

      def input_name
        "#{object_name}[#{association_primary_key || method}_in][]"
      end
    end
  end
end
