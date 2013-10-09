module ActiveAdmin
  module Comments

    module ResourceHelper
      extend ActiveSupport::Concern

      included do
        attr_accessor :comments
      end

      def comments?
        namespace.comments? && comments != false
      end
    end

  end
end
