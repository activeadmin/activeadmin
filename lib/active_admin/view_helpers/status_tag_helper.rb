module ActiveAdmin
  module ViewHelpers
    module StatusTagHelper

      def status_tag(*args)
        @status_tag ||= ActiveAdmin::Views::StatusTag.new
        @status_tag.status_tag(*args)
      end

    end
  end
end
