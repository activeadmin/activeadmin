module ActiveAdmin
  module ViewHelpers
    module StatusTagHelper

      def status_tag(status, options = {})
        options[:class] = ["status", status.try(:downcase), options[:class]].compact.join(' ')
        content_tag :span, status, options
      end

    end
  end
end
