module ActiveAdmin
  module Devise
    class ConfirmationsController < ::Devise::ConfirmationsController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end
