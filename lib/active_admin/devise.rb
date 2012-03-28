begin
  require 'devise'
rescue LoadError => e
  $stderr.puts ["You don't have Devise installed in your application. Please add it to your",
    "Gemfile and run bundle install. If you do not require Devise run the generator with",
    "--skip-users option"].join(' ')
  raise e
end


module ActiveAdmin
  module Devise

    def self.config
      config = {
        :path => ActiveAdmin.application.default_namespace,
        :controllers => ActiveAdmin::Devise.controllers,
        :path_names => { :sign_in => 'login', :sign_out => "logout" }
      }

      if ::Devise.respond_to?(:sign_out_via)
        logout_methods = [::Devise.sign_out_via, ActiveAdmin.application.logout_link_method].flatten.uniq
        config.merge!( :sign_out_via => logout_methods)
      end

      config
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
