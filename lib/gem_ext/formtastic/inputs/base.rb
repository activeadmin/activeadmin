module Formtastic
  module Inputs
    module Base

      # Overrides Formtastic's version to accept `.base`
      def humanized_method_name
        klass = object.respond_to?(:base) ? object.base : object.class
        if klass.respond_to? :human_attribute_name
          klass.human_attribute_name method
        else
          method.to_s.send builder.label_str_method
        end
      end

    end
  end
end
