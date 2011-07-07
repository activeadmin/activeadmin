module ActiveAdmin
  class ResourceController < ::InheritedResources::Base

    module Sidebars

      protected

      def skip_sidebar!
        @skip_sidebar = true
      end

      def skip_sidebar?
        @skip_sidebar == true
      end
    end

  end
end
