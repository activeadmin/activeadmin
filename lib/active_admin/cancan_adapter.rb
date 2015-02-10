unless ActiveAdmin::Dependency.cancan? || ActiveAdmin::Dependency.cancancan?
  ActiveAdmin::Dependency.cancan!
end

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

    def scope_collection(collection, action = ActiveAdmin::Auth::READ)
      collection.accessible_by(cancan_ability, action)
    end

    private

    def initialize_cancan_ability
      klass = resource.namespace.cancan_ability_class
      klass = klass.constantize if klass.is_a? String
      klass.new user
    end

  end

end
