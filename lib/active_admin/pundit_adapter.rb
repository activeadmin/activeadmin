# frozen_string_literal: true
ActiveAdmin::Dependency.pundit!

require "pundit"

# Add a setting to the application to configure the pundit default policy
ActiveAdmin::Application.inheritable_setting :pundit_default_policy, nil
ActiveAdmin::Application.inheritable_setting :pundit_policy_namespace, nil

module ActiveAdmin

  class PunditAdapter < AuthorizationAdapter

    def authorized?(action, subject = nil)
      policy = retrieve_policy(subject)
      action = format_action(action, subject)

      policy.respond_to?(action) && policy.public_send(action)
    end

    def scope_collection(collection, action = Auth::READ)
      # scoping is appliable only to read/index action
      # which means there is no way how to scope other actions
      Pundit.policy_scope!(user, namespace(collection))
    rescue Pundit::NotDefinedError => e
      if default_policy_class && default_policy_class.const_defined?(:Scope)
        default_policy_class::Scope.new(user, collection).resolve
      else
        raise e
      end
    end

    def retrieve_policy(subject)
      target = policy_target(subject)
      if (policy = policy(namespace(target)) || compat_policy(subject))
        policy
      elsif default_policy_class
        default_policy(subject)
      else
        raise Pundit::NotDefinedError, "unable to find a compatible policy for `#{target}`"
      end
    end

    def format_action(action, subject)
      # https://github.com/varvet/pundit/blob/master/lib/generators/pundit/install/templates/application_policy.rb
      case action
      when Auth::READ then subject.is_a?(Class) ? :index? : :show?
      when Auth::DESTROY then subject.is_a?(Class) ? :destroy_all? : :destroy?
      else "#{action}?"
      end
    end

    private

    def policy_target(subject)
      case subject
      when nil then resource
      when Class then subject.new
      else subject
      end
    end

    # This method is needed to fallback to our previous policy searching logic.
    # I.e.: when class name contains `default_policy_namespace` (eg: ShopAdmin)
    # we should try to search it without namespace. This is because that's
    # the only thing that worked in this case before we fixed our buggy namespace
    # detection, so people are probably relying on it.
    # This fallback might be removed in future versions of ActiveAdmin, so
    # pundit_adapter search will work consistently with provided namespaces
    def compat_policy(subject)
      return unless default_policy_namespace

      target = policy_target(subject)

      return unless target.class.to_s.include?(default_policy_module) &&
        (policy = policy(target))

      policy_name = policy.class.to_s

      Deprecation.warn "You have `pundit_policy_namespace` configured as `#{default_policy_namespace}`, " \
        "but ActiveAdmin was unable to find policy #{default_policy_module}::#{policy_name}. " \
        "#{policy_name} will be used instead. " \
        "This behavior will be removed in future versions of ActiveAdmin. " \
        "To fix this warning, move your #{policy_name} policy to the #{default_policy_module} namespace"

      policy
    end

    def namespace(object)
      if default_policy_namespace && !object.class.to_s.start_with?("#{default_policy_module}::")
        [default_policy_namespace.to_sym, object]
      else
        object
      end
    end

    def default_policy_class
      ActiveAdmin.application.pundit_default_policy && ActiveAdmin.application.pundit_default_policy.constantize
    end

    def default_policy(subject)
      default_policy_class.new(user, subject)
    end

    def default_policy_namespace
      ActiveAdmin.application.pundit_policy_namespace
    end

    def default_policy_module
      default_policy_namespace.to_s.camelize
    end

    def policy(target)
      policies[target] ||= Pundit.policy(user, target)
    end

    def policies
      @policies ||= {}
    end

  end

end
