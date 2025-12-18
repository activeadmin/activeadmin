# frozen_string_literal: true

ActiveAdmin::Dependency.action_policy!

require "action_policy"

# Add a setting to the application to configure the action policy default policy
ActiveAdmin::Application.inheritable_setting :action_policy_default_policy, nil
ActiveAdmin::Application.inheritable_setting :action_policy_namespace, nil
ActiveAdmin::Application.inheritable_setting :action_policy_scope_type, :active_admin

module ActiveAdmin
  class ActionPolicyAdapter < AuthorizationAdapter
    def authorized?(action, subject = nil)
      policy = retrieve_policy(subject)
      query = format_action(action, subject)

      policy.respond_to?(query) && policy.public_send(query)
    end

    def scope_collection(collection, _action = Auth::READ)
      target = policy_target(collection)
      policy_class = policy_class_for(target)

      if policy_class&.respond_to?(:apply_scope)
        policy_class.apply_scope(collection, user: user, type: default_scope_type)
      else
        collection
      end
    rescue ActionPolicy::NotFound => e
      raise e unless default_policy_class&.respond_to?(:scope_for)

      default_policy_class.scope_for(default_scope_type, user: user, scope: collection)
    end

    def retrieve_policy(subject)
      target = policy_target(subject)

      if (policy = policy_for(target))
        policy
      elsif default_policy_class
        default_policy(target)
      else
        raise ActionPolicy::NotFound, "Couldn't find policy class for #{target.inspect}"
      end
    end

    def format_action(action, subject)
      case action
      when Auth::READ then subject.is_a?(Class) ? :index? : :show?
      when Auth::DESTROY then subject.is_a?(Class) ? :destroy_all? : :destroy?
      else
        "#{action}?"
      end
    end

    private

    def policy_for(target)
      policies[target] ||= begin
        policy_class = policy_class_for(target)
        policy_class&.new(target, user: user)
      end
    rescue ActionPolicy::NotFound
      nil
    end

    def policy_class_for(target)
      if default_policy_namespace
        namespaced_policy_class(target)
      else
        ActionPolicy.lookup(target)
      end
    end

    def namespaced_policy_class(target)
      namespace_module = default_policy_namespace.to_s.camelize.constantize
      policy_name = "#{target.class.name}Policy"
      namespace_module.const_get(policy_name)
    rescue NameError, ArgumentError
      # Fallback to ActionPolicy.lookup if namespaced policy not found
      begin
        ActionPolicy.lookup(target)
      rescue ArgumentError, ActionPolicy::NotFound
        nil
      end
    end

    def policies
      @policies ||= {}
    end

    def default_policy_class
      policy = ActiveAdmin.application.action_policy_default_policy
      return nil unless policy

      policy.is_a?(String) ? policy.constantize : policy
    end

    def default_policy(target)
      default_policy_class.new(target, user: user)
    end

    def default_policy_namespace
      ActiveAdmin.application.action_policy_namespace
    end

    def default_scope_type
      ActiveAdmin.application.action_policy_scope_type&.to_sym
    end

    def policy_target(subject)
      case subject
      when nil then resource.resource_class
      when Class then subject.new
      else
        subject
      end
    end
  end
end
