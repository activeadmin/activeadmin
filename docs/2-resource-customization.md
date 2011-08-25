# Customize The Resource

## Rename the Resource

By default, any references to the resource (menu, routes, buttons, etc) in the
interface will use the name of the class. You can rename the resource by using
the <tt>:as</tt> option.

    ActiveAdmin.register Post, :as => "Article"

The resource will then be available as /admin/articles

## Customize the Menu

The resource will be displayed in the global navigation by default. To disable
the resource from being displayed in the global navigation, pass `false` to the
`menu` method:

    ActiveAdmin.register Post do
      menu false
    end

The menu method accepts a hash with the following options:

* `:label` - The string label to display in the menu
* `:parent` - The string label of the parent to set for this menu
* `:if` - A block or a symbol of a method to call to decide if the menu item
  should be displayed
* `:priority` - The integer value of the priority. Defaults to 10

### Labels

To change the name of the label in the menu:

    ActiveAdmin.register Post do
      menu :label => "My Posts"
    end

By default the menu uses a pluralized version of your resource name.

### Drop Down Menus

In many cases, a single level navigation will not be enough for the
administration of a production application. In that case, you can categorize
your resources and creating drop down menus to access them.

To add the menu as a child of another menu:

    ActiveAdmin.register Post do
      menu :parent => "Blog"
    end

Note, the "Blog" menu does not even have to exist yet. It will be generated on
the fly as a drop down list for you.

### Menu Priority

By default Active Admin sorts menus alphabetically. Some times you want specific
resources to show up at the beginning or the end of your menu.

Each menu item is given an integer priority value (default 10). You can set it
to edit the location of the menu item.

    ActiveAdmin.register Post do
      menu :priority => 1
    end

This would ensure that the Post menu item, is at the beginning of the menu.

### Conditionally Showing / Hiding Menu Items

Menu items can be shown or hidden at runtime using the `:if` option. 

    ActiveAdmin.register Post do
      menu :if => proc{ current_admin_user.can_edit_posts? }
    end

The `proc` will be called in the context of the view, so you have access to all
your helpers and current user session information.
