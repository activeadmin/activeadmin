# frozen_string_literal: true
module ActiveAdmin
  module Views
    # Build a StatusTag
    class StatusTag < ActiveAdmin::Component
      builder_method :status_tag

      def tag_name
        "span"
      end

      # @overload status_tag(status, options = {})
      #   @param [String] status the status to display.
      #   @param [Hash] options
      #   @option options [String] :class to override the default class
      #   @option options [String] :id to override the default id
      #   @option options [String] :label to override the default label
      #   @return [ActiveAdmin::Views::StatusTag]
      #
      # @example
      #   status_tag(true)
      #   # => <span class="status-tag" data-status="yes">Yes</span>
      #
      # @example
      #   status_tag(false)
      #   # => <span class="status-tag" data-status="no">No</span>
      #
      # @example
      #   status_tag(nil)
      #   # => <span class="status-tag" data-status="unset">Unknown</span>
      #
      # @example
      #   status_tag('In Progress')
      #   # => <span class="status-tag" data-status="in_progress">In Progress</span>
      #
      # @example
      #   status_tag('Active', class: 'important', id: 'status_123', label: 'on')
      #   # => <span class="status-tag important" id="status_123" data-status="active">on</span>
      #
      def build(status, options = {})
        label = options.delete(:label)
        classes = options.delete(:class)
        boolean_status = convert_to_boolean_status(status)
        status = boolean_status || status

        if status
          content = label || if s = status.to_s and s.present?
                               I18n.t "active_admin.status_tag.#{s.downcase}", default: s.titleize
                             end
        end

        super(content, options)
        add_class "status-tag"
        set_attribute("data-status", convert_status(status)) if status
        add_class(classes) if classes
      end

      protected

      def convert_to_boolean_status(status)
        case status
        when true, "true"
          "Yes"
        when false, "false"
          "No"
        when nil
          "Unset"
        end
      end

      def convert_status(status)
        case status
        when String, Symbol
          status.to_s.titleize.delete(" ").underscore
        end
      end
    end
  end
end
