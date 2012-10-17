require 'cancan'

module ActiveAdmin

  class CanCanAdapter < AuthorizationAdapter

    # Add a setting to the application to configure the ability
    ActiveAdmin::Application.inheritable_setting :cancan_ability_class, "Ability"

    def authorized?(action, subject = nil)
      cancan_ability.can?(action, subject)
    end

    def cancan_ability
      @cancan_ability ||= initialize_cancan_ability
    end

    def scope_collection(collection)
      collection.accessible_by(cancan_ability)
    end

    private

    def initialize_cancan_ability
      cancan_ability_class.new(user)
    end

    def cancan_ability_class
      if resource.namespace.cancan_ability_class.is_a?(String)
        ActiveSupport::Dependencies.constantize(resource.namespace.cancan_ability_class)
      else
        resource.namespace.cancan_ability_class
      end
    end

  end

end
