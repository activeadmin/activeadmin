require 'cancan'

# Add a setting to the application to configure the ability
ActiveAdmin::Application.inheritable_setting :cancan_ability_class, "Ability"

module ActiveAdmin

  class CanCanAdapter < AuthorizationAdapter

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

    # The setting allows the class to be stored as a string
    # to enable reloading in development.
    def initialize_cancan_ability
      ability_class_name = resource.namespace.cancan_ability_class

      if ability_class_name.is_a?(String)
        ability_class = ActiveSupport::Dependencies.constantize(ability_class_name)
      else
        ability_class = ability_class_name
      end

      ability_class.new(user)
    end

  end

end
