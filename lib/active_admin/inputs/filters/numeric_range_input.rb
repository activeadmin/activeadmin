# frozen_string_literal: true
module ActiveAdmin
  module Inputs
    module Filters
      class NumericRangeInput < ::Formtastic::Inputs::NumberInput
        include Base

        LOWER_BOUNDS = [:gt, :gteq].freeze
        UPPER_BOUNDS = [:lt, :lteq].freeze
        DEFAULT_FILTERS = [:gteq, :lteq].freeze

        def to_html
          input_wrapping do
            [ label_html,
              '<div class="filters-form-input-group">',
              builder.number_field(gt_input_name, input_html_options_for(gt_input_name, gt_input_placeholder)),
              builder.number_field(lt_input_name, input_html_options_for(lt_input_name, lt_input_placeholder)),
              '</div>'
            ].join("\n").html_safe
          end
        end

        # Lower and upper bound, in that order. Pass `filters: [:gt, :lt]` for
        # exclusive bounds; a subclass can override this for a different default.
        def filters
          @filters ||= Array(options[:filters] || DEFAULT_FILTERS).tap do |filters|
            lower, upper = filters
            unless filters.size == 2 && LOWER_BOUNDS.include?(lower) && UPPER_BOUNDS.include?(upper)
              raise ArgumentError, "#{self.class.name} expects a lower bound " \
                                   "(#{LOWER_BOUNDS.join(" or ")}) followed by an upper bound " \
                                   "(#{UPPER_BOUNDS.join(" or ")}), got #{filters.inspect}"
            end
          end
        end

        def gt_input_name
          "#{method}_#{filters[0]}"
        end
        alias :input_name :gt_input_name

        def lt_input_name
          "#{method}_#{filters[1]}"
        end

        # NumberInput falls back to "any" for every column type, which lets a
        # browser submit a decimal the database then truncates or rounds.
        def step_option
          return options[:step] if options.key?(:step)

          case column&.type
          when :integer then 1
          when :decimal then column.scale&.positive? ? 10.0**-column.scale : 1
          else "any"
          end
        end

        # The visible label names the pair, so it points at the lower bound. Each
        # field also carries its own name, since a placeholder is not one.
        def label_html_options
          super.merge(for: dom_id_for(gt_input_name))
        end

        # Caller options win over the defaults, as they do for a date range, but
        # the id stays per field: the two bounds cannot share one.
        def input_html_options_for(input_name, placeholder)
          input_html_options
            .merge(placeholder: placeholder,
                   "aria-label": "#{attribute_label} #{placeholder}",
                   value: @object.public_send(input_name).to_s)
            .merge(options[:input_html] || {})
            .merge(id: dom_id_for(input_name))
        end

        # A label is HTML, an attribute value is text, so the entities a browser
        # resolves in the visible label have to be resolved here instead. Decodes
        # the very string the label is built from, which cannot drift from it.
        def attribute_label
          @attribute_label ||= Loofah.fragment(localized_label || humanized_method_name)
            .text(encode_special_chars: false)
        end

        def dom_id_for(input_name)
          [builder.dom_id_namespace, sanitized_object_name, input_name].reject(&:blank?).join("_")
        end

        def gt_input_placeholder
          I18n.t("active_admin.filters.predicates.from", default: "From")
        end

        def lt_input_placeholder
          I18n.t("active_admin.filters.predicates.to", default: "To")
        end
      end
    end
  end
end
