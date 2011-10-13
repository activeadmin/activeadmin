module ActiveAdmin
  class CanCanAdapter < AuthorizationAdapter

    def initialize
    end

    def authorized?(*args)
      options = args.extract_options!

      # no user, nothing to check
      return false unless options[:current_user]

      ability = Ability.new(options[:current_user])

      if options[:resource]
        return ability.can?(options[:action], options[:resource])
      elsif options[:controller]
        return ability.can?(options[:action], options[:controller].camelcase)
      end

      false
    end

    def controller_before_filter
      proc { |_| load_and_authorize_resource }
    end

  end
end
