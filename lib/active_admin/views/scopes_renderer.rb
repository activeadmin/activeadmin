module ActiveAdmin
  module Views

    # Renders a collection of ActiveAdmin::Scope objects as a
    # simple list with a seperator
    class ScopesRenderer < Renderer

      def to_html(scopes)
        if scopes.any?
          content_tag :div, :class => "scopes" do
            scopes.collect do |scope|
              display_scope(scope)
            end.join(seperator).html_safe
          end
        else
          "".html_safe
        end
      end

      def display_scope(scope)
        content_tag :span, :class => classes_for_scope(scope) do
          content = current_scope?(scope) ? selected_scope(scope) : scope_link(scope)
          content + " " + scope_count(scope)
        end
      end

      def classes_for_scope(scope)
        classes = ["scope", scope.id]
        classes << "selected" if current_scope?(scope)
        classes.join(" ")
      end
      
      def scope_link(scope)
        link_to scope.name, params.merge(:scope => scope.id, :page => 1)
      end

      def selected_scope(scope)
        content_tag :em, scope.name
      end

      def current_scope?(scope)
        if params[:scope]
          params[:scope] == scope.id
        else
          active_admin_config.default_scope == scope
        end
      end

      def scope_count(scope)
        content_tag :span, :class => 'count' do
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
        @before_scope_collection || active_admin_config.resource
      end
      
      def seperator
        content_tag :span, " | ", :class => "scopes_seperator"
      end

    end
  end
end
