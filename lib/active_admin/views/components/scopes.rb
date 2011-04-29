module ActiveAdmin
  module Views

    # Renders a collection of ActiveAdmin::Scope objects as a
    # simple list with a seperator
    class Scopes < ActiveAdmin::Component
      builder_method :scopes_renderer

      def build(scopes)
        scopes.each do |scope|
          build_scope(scope)
        end
      end

      protected

      def build_scope(scope)
        span :class => classes_for_scope(scope) do
          if current_scope?(scope) 
            em(scope.name)
          else
            a(scope.name, :href => url_for(params.merge(:scope => scope.id, :page => 1)))
          end
          text_node(" ")
          scope_count(scope)
          text_node(" ")
        end
      end

      def classes_for_scope(scope)
        classes = ["scope", scope.id]
        classes << "selected" if current_scope?(scope)
        classes.join(" ")
      end

      def current_scope?(scope)
        if params[:scope]
          params[:scope] == scope.id
        else
          active_admin_config.default_scope == scope
        end
      end

      def scope_count(scope)
        span :class => 'count' do
          "(" + get_scope_count(scope).to_s + ")"
        end
      end

      def get_scope_count(scope)
        if scope.scope_method
          scoping_class.send(scope.scope_method).count
        else
          instance_exec(scoping_class, &scope.scope_block).count
        end
      end

      def scoping_class
        assigns["before_scope_collection"] || active_admin_config.resource
      end

    end
  end
end
