ActiveAdmin::Dependency.action_policy!

require "action_policy"

# Add a setting to the application to configure the action policy default policy
ActiveAdmin::Application.inheritable_setting :action_policy_default_policy, nil
ActiveAdmin::Application.inheritable_setting :action_policy_namespace, nil
ActiveAdmin::Application.inheritable_setting :action_policy_scope_type, :active_admin

module ActiveAdmin
  class ActionPolicyAdapter < AuthorizationAdapter
    def authorized?(action, subject = nil)
      action = format_action(action, subject)
      retrieve_policy(subject).apply(action)
    end

    def scope_collection(collection, _action = Auth::READ)
      retrieve_policy(collection).apply_scope(collection, type: default_scope_type)
    end

    def retrieve_policy(subject)
      target = policy_target(subject)
      @policies ||= {}
      @policies[target] ||= ActionPolicy.lookup(target, namespace: default_policy_module)
      @policies[target].new(target, user: user)
    rescue ActionPolicy::NotFound
      if default_policy_class
        default_policy(subject)
      else
        raise ActionPolicy::NotFound, "unable to find a compatible policy for `#{target}`"
      end
    end

    def format_action(action, subject)
      case action
      when Auth::READ then subject.is_a?(Class) ? :index? : :show?
      when Auth::DESTROY then subject.is_a?(Class) ? :destroy_all? : :destroy?
      else "#{action}?"
      end
    end

    private

    def default_policy
      ActiveAdmin.application.action_policy_default_policy
    end

    def default_policy_class
      return if default_policy.nil?

      default_policy.to_s.camelize.constantize
    end

    def default_policy_namespace
      ActiveAdmin.application.action_policy_namespace
    end

    def default_policy_module
      return if default_policy_namespace.nil?

      default_policy_namespace.to_s.camelize.constantize
    end

    def default_scope_type
      ActiveAdmin.application.action_policy_scope_type&.to_sym
    end

    def policy_target(subject)
      case subject
      when nil then resource.resource_class
      when Class then subject.new
      else subject
      end
    end

    def apply_namespace(subject)
      return subject unless default_policy_namespace
      return subject if subject.class.to_s.start_with?("#{default_policy_module}::")

      [default_policy_namespace.to_sym, subject]
    end
  end
end
