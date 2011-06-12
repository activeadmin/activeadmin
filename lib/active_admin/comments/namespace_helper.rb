module ActiveAdmin
  module Comments

    module NamespaceHelper

      # Returns true of the namespace allows comments
      def comments?
        application.allow_comments_in && application.allow_comments_in.include?(name)
      end

    end

  end
end
