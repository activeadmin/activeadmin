# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class DateRangeInput < ::Formtastic::Inputs::StringInput
        include Base

        def to_html
          input_wrapping do
            [ label_html,
              builder.text_field(gt_input_name, input_html_options_for(gt_input_name, gt_input_placeholder)),
              builder.text_field(lt_input_name, input_html_options_for(lt_input_name, lt_input_placeholder)),
            ].join("\n").html_safe
          end
        end

        def gt_input_name
          column && column.type == :date ? "#{method}_gteq" : "#{method}_gteq_datetime"
        end
        alias :input_name :gt_input_name

        def lt_input_name
          column && column.type == :date ? "#{method}_lteq" : "#{method}_lteq_datetime"
        end

        def input_html_options
          { size: 12,
            class: "datepicker",
            maxlength: 10 }.merge(options[:input_html] || {})
        end

        def input_html_options_for(input_name, placeholder)
          current_value = begin
                            #cast value to date object before rendering input
                            @object.public_send(input_name).to_s.to_date
                          rescue
                            nil
                          end
          { placeholder: placeholder,
            value: current_value ? current_value.strftime("%Y-%m-%d") : "" }.merge(input_html_options)
        end

        def gt_input_placeholder
          I18n.t("active_admin.filters.predicates.from")
        end

        def lt_input_placeholder
          I18n.t("active_admin.filters.predicates.to")
        end
      end
    end
  end
end
