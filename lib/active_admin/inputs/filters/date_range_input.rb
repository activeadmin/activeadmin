module ActiveAdmin
  module Inputs
    module Filters
      class DateRangeInput < ::Formtastic::Inputs::StringInput
        include Base

        def to_html
          input_wrapping do
            [ label_html,
              builder.text_field(gt_input_name, input_html_options(gt_input_name)),
              template.content_tag(:span, "-", class: "seperator"),
              builder.text_field(lt_input_name, input_html_options(lt_input_name)),
            ].join("\n").html_safe
          end
        end

        def gt_input_name
          "#{method}_gteq_date"
        end
        alias :input_name :gt_input_name

        def lt_input_name
          "#{method}_lteq_date"
        end

        def input_html_options(input_name = gt_input_name)
          current_value = @object.public_send input_name
          { size: 12,
            class: "datepicker",
            maxlength: 10,
            value: current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : "" }
        end
      end
    end
  end
end
