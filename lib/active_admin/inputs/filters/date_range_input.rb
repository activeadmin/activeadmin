# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class DateRangeInput < ::Formtastic::Inputs::StringInput
        include Base

        def to_html
          input_wrapping do
            [ label_html,
              '<div class="filters-form-input-group">',
              builder.date_field(gt_input_name, input_html_options_for(gt_input_name, gt_input_placeholder)),
              builder.date_field(lt_input_name, input_html_options_for(lt_input_name, lt_input_placeholder)),
              '</div>'
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

        def input_html_options_for(input_name, placeholder)
          { value: input_value_for(input_name),
            placeholder: placeholder,
            size: 12,
            class: "datepicker",
            maxlength: 10 }.merge(options[:input_html] || {})
        end

        def input_value_for(input_name)
          @object.public_send(input_name).to_date.to_s
        rescue
          ""
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
