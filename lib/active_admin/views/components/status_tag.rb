module ActiveAdmin
  module Views
    # Build a StatusTag
    class StatusTag < ActiveAdmin::Component
      builder_method :status_tag

      def tag_name
        'span'
      end

      def default_class_name
        'status_tag'
      end

      # @overload status_tag(status, type = nil, options = {})
      #   @param [String] status the status to display. One of the span classes will be an underscored version of the status.
      #   @param [Symbol] type type of status. Will become a class of the span. ActiveAdmin provide style for :ok, :warning and :error.
      #   @param [Hash] options
      #   @option options [String] :class to override the default class
      #   @option options [String] :id to override the default id
      #   @option options [String] :label to override the default label
      #   @return [ActiveAdmin::Views::StatusTag]
      #
      # @example
      #   status_tag('In Progress')
      #   # => <span class='status_tag in_progress'>In Progress</span>
      #
      # @example
      #   status_tag('active', :ok)
      #   # => <span class='status_tag active ok'>Active</span>
      #
      # @example
      #   status_tag('active', :ok, class: 'important', id: 'status_123', label: 'on')
      #   # => <span class='status_tag active ok important' id='status_123'>on</span>
      #
      def build(*args)
        options = args.extract_options!
        status = args[0]
        type = args[1]
        label = options.delete(:label)
        classes = options.delete(:class)
        status = convert_to_boolean_status(status)

        if status
          content = label || if s = status.to_s and s.present?
            I18n.t "active_admin.status_tag.#{s.downcase}", default: s.titleize
          end
        end

        super(content, options)

        add_class(status_to_class(status)) if status
        add_class(type.to_s) if type
        add_class(classes) if classes
      end

      protected

      def convert_to_boolean_status(status)
        if status == 'true'
          'Yes'
        elsif ['false', nil].include?(status)
          'No'
        else
          status
        end
      end

      def status_to_class(status)
        case status
        when String, Symbol
          status.to_s.titleize.gsub(/\s/, '').underscore
        else
          ''
        end
      end
    end
  end
end
