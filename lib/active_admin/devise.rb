require 'devise'

module ActiveAdmin
  module Devise

    def self.config
      {
        :path => ActiveAdmin.default_namespace,
        :controllers => ActiveAdmin::Devise.controllers,
        :path_names => { :sign_in => 'login', :sign_out => "logout" }
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
        "/#{ActiveAdmin.default_namespace}"
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
