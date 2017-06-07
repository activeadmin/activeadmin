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

      # @overload status_tag(status, options = {})
      #   @param [String] status the status to display. One of the span classes will be an underscored version of the status.
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
      #   status_tag('active', class: 'important', id: 'status_123', label: 'on')
      #   # => <span class='status_tag active important' id='status_123'>on</span>
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

        if type
          Deprecation.warn <<-MSG.strip_heredoc
            The `type` parameter has been deprecated. Provide the "#{type}" type as
            a class instead. For example, `status_tag(status, :#{type}, class: "abc")`
            would change to `status_tag(status, class: "#{type} abc")`. Also note that
            the "#{type}" CSS rule will be removed too, so you'll have to provide
            the styles yourself. See https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md#110-
            for more information.
          MSG
          add_class(type.to_s)
        end

        add_class(classes) if classes
      end

      protected

      def convert_to_boolean_status(status)
        case status
        when true, 'true'
          'Yes'
        when false, 'false', nil
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
