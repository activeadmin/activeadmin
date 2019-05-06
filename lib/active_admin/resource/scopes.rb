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
        scopes.find { |s| s.id == id }
      end

      def default_scope(context = nil)
        scopes.detect do |scope|
          if scope.default_block.is_a?(Proc)
            render_in_context(context, scope.default_block)
          else
            scope.default_block
          end
        end
      end

      # Create a new scope object for this resource.
      # If you want to internationalize the scope name, you can add
      # to your i18n files a key like "active_admin.scopes.scope_method".
      def scope(*args, &block)
        default_options = { show_count: namespace.scopes_show_count }
        options = default_options.merge(args.extract_options!)
        title = args[0] rescue nil
        method = args[1] rescue nil

        options[:localizer] ||= ActiveAdmin::Localizers.resource(self)
        scope = ActiveAdmin::Scope.new(title, method, options, &block)

        # Finds and replaces a scope by the same name if it already exists
        existing_scope_index = scopes.index { |existing_scope| existing_scope.id == scope.id }
        if existing_scope_index
          scopes.delete_at(existing_scope_index)
          scopes.insert(existing_scope_index, scope)
        else
          self.scopes << scope
        end

        scope
      end

    end
  end
end
