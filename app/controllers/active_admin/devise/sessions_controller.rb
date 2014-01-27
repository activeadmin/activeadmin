module ActiveAdmin
  module Devise
    class SessionsController < ::Devise::SessionsController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end
