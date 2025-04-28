module ActiveAdmin
  class ActionPolicyAdapter < AuthorizationAdapter
    def authorized?(action, subject = nil)
      target = policy_target(subject)
      policy = ActionPolicy.lookup(target)
      action = format_action(action, subject)
      policy.new(target, user: user).apply(action)
    end

    def scope_collection(collection, _action = Auth::READ)
      target = policy_target(collection)
      policy = ActionPolicy.lookup(target)
      policy.new(user: user).apply_scope(collection, type: :active_admin)
    end

    def format_action(action, subject)
      case action
      when Auth::CREATE
        :create?
      when Auth::UPDATE
        :update?
      when Auth::READ
        subject.is_a?(Class) ? :index? : :show?
      when Auth::DESTROY
        subject.is_a?(Class) ? :destroy_all? : :destroy?
      else
        "#{action}?"
      end
    end

    private

    def policy_target(subject)
      case subject
      when nil
        resource.resource_class
      when Class
        subject.new
      else
        subject
      end
    end
  end
end
