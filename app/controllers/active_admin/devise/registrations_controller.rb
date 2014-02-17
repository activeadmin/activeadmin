module ActiveAdmin
  module Devise
    class RegistrationsController < ::Devise::RegistrationsController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end
