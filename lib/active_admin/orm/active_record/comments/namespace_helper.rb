# frozen_string_literal: true
module ActiveAdmin
  module Comments

    module NamespaceHelper

      # Returns true if the namespace allows comments
      def comments?
        comments == true
      end

    end

  end
end
