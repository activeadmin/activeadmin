module ActiveAdmin
  module Devise
    class PasswordsController < ::Devise::PasswordsController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end
