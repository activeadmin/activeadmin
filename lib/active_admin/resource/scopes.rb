module ActiveAdmin
  class Resource
    module Scopes

      # Return an array of scopes for this resource
      def scopes
        @scopes ||= []
      end

      # Returns a scope for this object by its identifier
      def get_scope_by_id(id)
        id = id.to_s
        scopes.find{|s| s.id == id }
      end

      def default_scope
        @default_scope
      end

      # Create a new scope object for this resource.
      # If you want to internationalize the scope name, you can add
      # to your i18n files a key like "active_admin.scopes.scope_method".
      def scope(*args, &block)
        options = args.extract_options!
        self.scopes << ActiveAdmin::Scope.new(*args, &block)
        if options[:default]
          @default_scope = scopes.last
        end
      end

    end
  end
end
