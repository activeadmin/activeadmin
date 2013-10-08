module ActiveAdmin
  module Comments

    module NamespaceHelper

      # Returns true of the namespace allows comments
      def comments?
        allow_comments == true
      end

    end

  end
end
