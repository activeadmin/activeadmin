module ActiveAdmin
  module Comments

    module NamespaceHelper

      # Returns true of the namespace allows comments
      def comments?
        ActiveAdmin.allow_comments_in && ActiveAdmin.allow_comments_in.include?(name)
      end

    end

  end
end
