ActiveAdmin::Dependency.pundit!

require 'pundit'

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
      case subject
      when nil   then Pundit.policy!(user, namespace(resource))
      when Class then Pundit.policy!(user, namespace(subject.new))
      else Pundit.policy!(user, namespace(subject))
      end
    rescue Pundit::NotDefinedError => e
      if default_policy_class
        default_policy(user, subject)
      else
        raise e
      end
    end

    def format_action(action, subject)
      # https://github.com/varvet/pundit/blob/master/lib/generators/pundit/install/templates/application_policy.rb
      case action
      when Auth::CREATE  then :create?
      when Auth::UPDATE  then :update?
      when Auth::READ    then subject.is_a?(Class) ? :index? : :show?
      when Auth::DESTROY then subject.is_a?(Class) ? :destroy_all? : :destroy?
      else "#{action}?"
      end
    end

    private

    def namespace(object)
      if default_policy_namespace && !object.class.to_s.include?(default_policy_namespace.to_s.camelize)
        [default_policy_namespace.to_sym, object]
      else
        object
      end
    end

    def default_policy_class
      ActiveAdmin.application.pundit_default_policy && ActiveAdmin.application.pundit_default_policy.constantize
    end

    def default_policy(user, subject)
      default_policy_class.new(user, subject)
    end

    def default_policy_namespace
      ActiveAdmin.application.pundit_policy_namespace
    end

  end

end
