module ActiveAdmin
  module ViewHelpers
    module FlashMessageHelper

      def flash_messages
        if flash.keys.any?
          content_tag :div, :class => 'flashes' do
            flash.collect do |type, message|
              content_tag :div, message, :class => "flash flash_#{type}"
            end.join
          end
        end
      end

    end
  end
end
