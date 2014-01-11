require 'pundit'

module ActiveAdmin

  class PunditAdapter < AuthorizationAdapter

    def authorized?(action, subject = nil)
      case subject
      when nil
        scope_collection(resource).any?
      when Class
        scope_collection(subject).any?
      else
        action = :show if action == ActiveAdmin::Auth::READ
        Pundit.policy!(user, subject).send("#{action}?")
      end
    end

    def scope_collection(collection, action = ActiveAdmin::Auth::READ)
      # scoping is appliable only to read/index action
      # which means there is no way how to scope other actions
      Pundit.policy_scope!(user, collection)
    end

  end

end
