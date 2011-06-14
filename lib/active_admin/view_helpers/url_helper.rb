module ActiveAdmin
  module ViewHelpers
    module UrlHelper

      def logout_path
        "/#{ActiveAdmin.default_namespace}/logout"
      end

    end
  end
end
