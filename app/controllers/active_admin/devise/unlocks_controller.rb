module ActiveAdmin
  module Devise
    class UnlocksController < ::Devise::UnlocksController
      include ::ActiveAdmin::Devise::Controller
    end
  end
end
