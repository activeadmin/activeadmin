# Working with Resources

Every Active Admin resource corresponds to a Rails model. So before creating a 
resource you must first create a Rails model for it.

## Create a Resource

The basic command for creating a resource is `rails g active_admin:resource Post`. 
The generator will produce an empty `app/admin/post.rb` file like so:

    ActiveAdmin.register Post do
      # everything happens here :D
    end

## Setting up Strong Parameters

Rails 4 replaces `attr_accessible` with [Strong Parameters](https://github.com/rails/strong_parameters),
which moves attribute whitelisting from the model to the controller. There are
talks ([#2594](https://github.com/gregbell/active_admin/issues/2594)) on providing a
cleaner DSL, but for now you do so like this:

    ActiveAdmin.register Post do
      controller do
        def permitted_params
          params.permit post: [:title, :content, :author]
        end
      end
    end

## Disabling Actions on a Resource

All CRUD actions are enabled by default. These can be disabled for a given resource:

    ActiveAdmin.register Post do
      actions :all, except: [:update, :destroy]
    end

## Rename the Resource

By default, any references to the resource (menu, routes, buttons, etc) in the
interface will use the name of the class. You can rename the resource by using
the `:as` option.

    ActiveAdmin.register Post, as: "Article"

The resource will then be available at `/admin/articles`.

This will also change the key of the resource params passed to the controller.
In Rails 4, the `permitted_params` key will need to be changed from `:post` to `:article`.

## Customize the Namespace

We use the `admin` namespace by default, but you can use anything:

    # Available at /today/posts
    ActiveAdmin.register Post, namespace: :today

    # Available at /posts
    ActiveAdmin.register Post, namespace: false


## Customize the Menu

The resource will be displayed in the global navigation by default. To disable
the resource from being displayed in the global navigation:

    ActiveAdmin.register Post do
      menu false
    end

The menu method accepts a hash with the following options:

* `:label` - The string or proc label to display in the menu. If it's a proc, it
  will be called each time the menu is rendered.
* `:parent` - The string id (or label) of the parent used for this menu
* `:if` - A block or a symbol of a method to call to decide if the menu item
  should be displayed
* `:priority` - The integer value of the priority, which defaults to `10`

### Labels

To change the name of the label in the menu:

    ActiveAdmin.register Post do
      menu label: "My Posts"
    end

If you want something more dynamic, pass a proc instead:

    ActiveAdmin.register Post do
      menu label: proc{ I18n.t("mypost") }
    end

### Menu Priority

Menu items are sorted first by their numeric priority, then alphabetically. Since
every menu by default has a priority of `10`, the menu is normally alphabetical.

You can easily customize this:

    ActiveAdmin.register Post do
      menu priority: 1 # so it's on the very left
    end

### Conditionally Showing / Hiding Menu Items

Menu items can be shown or hidden at runtime using the `:if` option.

    ActiveAdmin.register Post do
      menu if: proc{ current_admin_user.can_edit_posts? }
    end

The proc will be called in the context of the view, so you have access to all
your helpers and current user session information.

### Drop Down Menus

In many cases, a single level navigation will not be enough to manage a large
application. In that case, you can group your menu items under a parent menu item.

    ActiveAdmin.register Post do
      menu parent: "Blog"
    end

Note that the "Blog" parent menu item doesn't even have to exist yet; it can be
dynamically generated for you.

### Customizing Parent Menu Items

All of the options given to a standard menu item are also available to
parent menu items. In the case of complex parent menu items, you should
configure them in the Active Admin initializer.

    # config/initializers/active_admin.rb
    config.namespace :admin do |admin|
      admin.build_menu do |menu|
        menu.add label: 'Blog', priority: 0
      end
    end

    # app/admin/post.rb
    ActiveAdmin.register Post do
      menu parent: 'Blog'
    end

### Dynamic Parent Menu Items

While the above works fine, what if you want a parent menu item with a dynamic
name? Well, you have to refer to it by its `:id`.

    # config/initializers/active_admin.rb
    config.namespace :admin do |admin
      admin.build_menu do |menu|
        menu.add id: 'blog', label: proc{"Something dynamic"}, priority: 0
      end
    end

    # app/admin/post.rb
    ActiveAdmin.register Post do
      menu parent: 'blog'
    end

### Adding Custom Menu Items

Sometimes it's not enough to just customize the menu label. In this case, you
can customize the menu for the namespace within the Active Admin initializer.

    # config/initializers/active_admin.rb
    config.namespace :admin do |admin|
      admin.build_menu do |menu|
        menu.add label: "The Application", url: "/", priority: 0

        menu.add label: "Sites" do |sites|
          sites.add label: "Google",   url: "http://google.com", html_options: { target: :blank }
          sites.add label: "Facebook", url: "http://facebook.com"
          sites.add label: "Github",   url: "http://github.com"
        end
      end
    end

This will be registered on application start before your resources are loaded.

## Scoping the queries

If your administrators have different access levels, you may sometimes want to
scope what they have access to. Assuming your User model has the proper
has_many relationships, you can simply scope the listings and finders like so:

    ActiveAdmin.register Post do
      scope_to :current_user

      # Or if the association doesn't have the default name:
      scope_to :current_user, association_method: :blog_posts
    end

That approach limits the posts an admin can access to `current_user.posts`.

If you want to conditionally apply the scope, then there are options for that as well:

    ActiveAdmin.register Post do
      # Only scope the query if there is a user to scope to, helper provided via Devise
      scope_to :current_user, if: proc{ admin_user_signed_in? }

      # Don't scope the query if the user is an admin
      scope_to :current_user, unless: proc{ current_admin_user.admin? }

      # Get fancy and can combine with block syntax
      scope_to if: proc{ admin_user_signed_in? } do
        User.most_popular
      end
    end

If you want to do something fancier, for example override a default scope, you
can also use `:association_method`. The only requirement here is that your
method returns an instance of ActiveRecord::Relation.

    class Ad < ActiveRecord::Base
      default_scope ->{ where published: true }
    end

    class User < ActiveRecord::Base
      def managed_ads
        Ad.unscoped
      end
    end

    ActiveAdmin.register Ad do
      scope_to :current_user, association_method: :managed_ads
    end

In case you just need to customize the query independently of the current user, you can
override the `scoped_collection` method on the controller:

    ActiveAdmin.register Post do
      controller do
        def scoped_collection
          Post.includes :author
        end
      end
    end

## Customizing resource retrieval

If you need to completely replace the record retrieving code (e.g., you have a custom
`to_param` implementation in your models), override the `resource` method on the controller:

    ActiveAdmin.register Post do
      controller do
        def resource
          Post.where(id: params[:id]).first!
        end
      end
    end

Our controllers are built on [Inherited Resources](https://github.com/josevalim/inherited_resources),
so you can use [all of its features](https://github.com/josevalim/inherited_resources#overwriting-defaults).

## Belongs To

It's common to want to scope a series of resources to a relationship. For
example a Project may have many Milestones and Tickets. To nest the resource
within another, you can use the `belongs_to` method:

    ActiveAdmin.register Project
    ActiveAdmin.register Ticket do
      belongs_to :project
    end

Projects will be available as usual and tickets will be availble by visiting
`/admin/projects/1/tickets` assuming that a Project with the id of 1 exists.
Active Admin does not add "Tickets" to the global navigation because the routes
can only be generated when there is a project id.

To create links to the resource, you can add them to a sidebar (one of the many
possibilities for how you may with to handle your user interface):

    ActiveAdmin.register Project do

      sidebar "Project Details", only: [:show, :edit] do
        ul do
          li link_to "Tickets",    admin_project_tickets_path(project)
          li link_to "Milestones", admin_project_milestones_path(project)
        end
      end

    end

    ActiveAdmin.register Ticket do
      belongs_to :project
    end

    ActiveAdmin.register Milestone do
      belongs_to :project
    end

In some cases (like Projects), there are many sub resources and you would
actually like the global navigation to switch when the user navigates "into" a
project. To accomplish this, Active Admin stores the `belongs_to` resources in a
seperate menu which you can use if you so wish. To use:

    ActiveAdmin.register Ticket do
      belongs_to :project
      navigation_menu :project
    end

    ActiveAdmin.register Milestone do
      belongs_to :project
      navigation_menu :project
    end

Now, when you navigate to the tickets section, the global navigation will
only display "Tickets" and "Milestones". When you navigate back to a
non-belongs_to resource, it will switch back to the default menu.

You can also defer the menu lookup until runtime so that you can dynamically show
different menus, say perhaps based on user permissions. For example:

    ActiveAdmin.register Ticket do
      belongs_to: :project
      navigation_menu do
        authorized?(:manage, SomeResource) ? :project : :restricted_menu
      end
    end
