# Sidebar Sections

To add a sidebar section to all the screen within a section, use the sidebar method:

    sidebar :help do
      "Need help? Email us at help@example.com"
    end

This will generate a sidebar on every page for that resource. The first
argument is used as the title, and can be a symbol, string, or lambda.

You can also use [Arbre](https://github.com/gregbell/arbre) to define HTML content.

    sidebar :help do
      ul do
        li "Second List First Item"
        li "Second List Second Item"
      end
    end

Sidebar sections can be rendered on a specific action by using the :only or :except
options.

    sidebar :help, only: :index do
      "Need help? Email us at help@example.com"
    end

If you want to conditionally display a sidebar section, use the :if option and
pass it a proc which will be rendered within the context of the view.

    sidebar :help, if: proc{ current_admin_user.super_admin? } do
      "Only for super admins!"
    end

If you only pass a symbol, Active Admin will attempt to locate a partial to render.

    # Will render app/views/admin/posts/_help_sidebar.html.erb
    sidebar :help

Or you can pass your own custom partial to render.

    sidebar :help, partial: "custom_help_partial"
