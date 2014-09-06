module ActiveAdmin
  module ViewHelpers
    module BlankSlateHelper

      def blank_slate(context)
        @blank_slate ||= ActiveAdmin::Views::BlankSlate.new
        @blank_slate.blank_slate(context)
      end

    end
  end
end
