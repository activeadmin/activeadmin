# frozen_string_literal: true
module ActiveAdmin
  module Views
    class BlankSlate < ActiveAdmin::Component
      builder_method :blank_slate

      def default_class_name
        "blank-slate"
      end
    end
  end
end
