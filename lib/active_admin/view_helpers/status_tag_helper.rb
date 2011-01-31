module ActiveAdmin
  module ViewHelpers
    module StatusTagHelper

      def status_tag(status, options = {})
        options[:class] ||= ""
        options[:class] << ["status", status.downcase].join(' ')
        content_tag :span, status, options
      end

    end
  end
end
