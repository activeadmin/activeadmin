# frozen_string_literal: true
module ActiveAdmin
  module Comments

    module ResourceHelper
      extend ActiveSupport::Concern

      included do
        attr_accessor :comments
      end

      def comments?
        (namespace.comments? && comments != false) || comments == true
      end
    end

  end
end
