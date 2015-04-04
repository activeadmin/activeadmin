module ActiveAdmin
  module Inputs
    module Filters
      class DateRangeInput < ::Formtastic::Inputs::StringInput
        include Base

        def to_html
          input_wrapping do
            [ label_html,
              builder.text_field(gt_input_name, input_html_options(gt_input_name, gt_input_placeholder)),
              builder.text_field(lt_input_name, input_html_options(lt_input_name, lt_input_placeholder)),
            ].join("\n").html_safe
          end
        end

        def gt_input_name
          "#{method}_gteq"
        end
        alias :input_name :gt_input_name

        def lt_input_name
          "#{method}_lteq"
        end

        def gt_input_placeholder
          I18n.t("active_admin.filters.predicates.starts_with")
        end

        def lt_input_placeholder
          I18n.t("active_admin.filters.predicates.ends_with")
        end

        def input_html_options(input_name = gt_input_name, input_placeholder = gt_input_placeholder)
          current_value = @object.public_send input_name
          { size: 12,
            class: "datepicker",
            max: 10,
            placeholder: input_placeholder,
            value: current_value.respond_to?(:strftime) ? current_value.strftime("%Y-%m-%d") : "" }
        end
      end
    end
  end
end
