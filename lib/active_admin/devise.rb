require 'devise'

module ActiveAdmin
  module Devise

    def self.config
      {
        :path => ActiveAdmin.application.default_namespace,
        :controllers => ActiveAdmin::Devise.controllers,
        :path_names => { :sign_in => 'login', :sign_out => "logout" },
        # Support sign_out via :get and Devise default (:get or :delete depending on version)
        :sign_out_via => [::Devise.sign_out_via, :get].flatten.uniq
      }
    end

    def self.controllers
      {
        :sessions => "active_admin/devise/sessions",
        :passwords => "active_admin/devise/passwords"
      }
    end

    module Controller
      extend ::ActiveSupport::Concern
      included do
        layout 'active_admin_logged_out'
        helper ::ActiveAdmin::ViewHelpers
      end

      # Redirect to the default namespace on logout
      def root_path
        if ActiveAdmin.application.default_namespace
          "/#{ActiveAdmin.application.default_namespace}"
        else
          "/"
        end
      end
    end

    class SessionsController < ::Devise::SessionsController
      include ::ActiveAdmin::Devise::Controller
    end

    class PasswordsController < ::Devise::PasswordsController
      include ::ActiveAdmin::Devise::Controller
    end

  end
end
