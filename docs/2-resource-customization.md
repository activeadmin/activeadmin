# Customize The Resource

## Rename the Resource

By default, any references to the resource (menu, routes, buttons, etc) in the
interface will use the name of the class. You can rename the resource by using
the <tt>:as</tt> option.

    ActiveAdmin.register Post, :as => "Article"

The resource will then be available as /admin/articles

## Customize the Namespace

By default, resources live in the "admin" namespace.

You can register resources in different namespaces:

    # Available at /today/posts
    ActiveAdmin.register Post, :namespace => "today"

    # Available at /posts
    ActiveAdmin.register Post, :namespace => false


## Customize the Menu

The resource will be displayed in the global navigation by default. To disable
the resource from being displayed in the global navigation, pass `false` to the
`menu` method:

    ActiveAdmin.register Post do
      menu false
    end

The menu method accepts a hash with the following options:

* `:label` - The string or proc label to display in the menu. If it's a proc, it
  will be called each time the menu is rendered.
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

If you wish to translate your label at runtime, store the label as a proc
instead of a string. The proc will be called each time the menu is rendered.

    ActiveAdmin.register Post do
      menu :label => proc{ I18n.t("mypost") }
    end

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

## Scoping the queries

If your administrators have different access levels, you may sometimes want to 
scope what they have access to. Assuming your User model has the proper 
has_many relationships, you can simply scope the listings and finders like so:

    ActiveAdmin.register Post do
      scope_to :current_user

      # or if the association doesn't have the default name.
      # scope_to :current_user, :association_method => :blog_posts
    end

That approach limits the posts an admin can access to ```current_user.posts```.

If you want to do something fancier, for example override a default scope, you can 
also use :association_method parameter with a normal method on your User model. 
The only requirement is that your method returns an instance of ActiveRecord::Relation.

    class Ad < ActiveRecord::Base
      default_scope lambda { where :published => true }
    end

    class User < ActiveRecord::Base
      def managed_ads
        # Overrides Ad's default_scope
        Ad.unscoped
      end
    end

    ActiveAdmin.register Ad do
      scope_to :current_user, :association_method => :managed_ads
    end

In case you just need to customize the query independently of the current user, you can 
override the `scoped_collection` method on the controller:

    ActiveAdmin.register Post do
      controller do
        def scoped_collection
          Post.includes(:author)
        end
      end
    end
