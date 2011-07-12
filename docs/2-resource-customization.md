# Customize The Resource

## Rename the Resource

By default, any references to the resource (menu, routes, buttons, etc) in the
interface will use the name of the class. You can rename the resource by using
the <tt>:as</tt> option.

    ActiveAdmin.register Post, :as => "Article"

The resource will then be available as /admin/articles

## Customize the Navigation

The resource will be displayed in the global navigation by default.

To disable the resource from being displayed in the global navigation:

    ActiveAdmin.register Post do
      menu false
    end

To change the name of the label in the menu:

    ActiveAdmin.register Post do
      menu :label => "My Posts"
    end

To add the menu as a child of another menu:

    ActiveAdmin.register Post do
      menu :parent => "Blog"
    end

This will create the menu item if it doesn't exist yet.
