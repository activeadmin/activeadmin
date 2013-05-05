# Resource Customization

## Name

Any references to the resource (menu, routes, buttons, etc) in the interface
will normally use the class name. You can change that with the `:as` option.
```ruby
ActiveAdmin.register Post, as: "Article"
```

## Namespace

If you don't specify, resources live in the application's `default_namespace`.
```ruby
ActiveAdmin.register Post, namespace: "today" # Available at /today/posts
ActiveAdmin.register Post, namespace: false   # Available at /posts
```

## Menu

To remove the menu item entirely, pass false as the only parameter:
```ruby
ActiveAdmin.register Post do
  menu false
end
```

The `menu` method accepts a hash with the following options:

* `:label`  - The string or proc label to display in the menu.
* `:parent` - The string ID of the parent menu item.
* `:if` - A proc to evaluate or a symbol method name to call.
* `:priority` - The integer value of the priority. Defaults to 10

### Labels

By default the menu uses a pluralized version of your resource name.

If you wish to translate your label at runtime, store the label as a proc
instead of a string. The proc will be called each time the menu is rendered.
```ruby
ActiveAdmin.register Post do
  menu label: proc{ I18n.t :post }
end
```

### Menu Priority

Active Admin sorts menu items first by their numerical priority, then by their label.
Since menus default to a priority of 10, at the beginning everything is alphabetical.

If you wanted Posts to show up as the leftmost menu item, you'd do this:
```ruby
ActiveAdmin.register Post do
  menu priority: 1
end
```

### Conditional Display

Menu items can be shown or hidden at runtime using the `:if` option.
```ruby
ActiveAdmin.register Post do
  menu if: proc{ current_admin_user.can_edit_posts? }
end
```

The `proc` will be called in the view context, so you have access to all
your helpers and session information.

### Drop Down Menus

You can group resources under a drop-down menu item for better organization.
```ruby
ActiveAdmin.register Post do
  menu parent: "Blog"
end
```

The `Blog` menu item doesn't have to exist yet; it will be generated dynamically.

### Parent Menu Items

All of the options given to a standard menu item are also available to the
parent menu items. You can customize their attributes in the Active Admin
initializer.
```ruby
# config/initializers/active_admin.rb
config.namespace :admin do |admin|
  admin.build_menu do |menu|
    menu.add label: "Blog", priority: 0
  end
end
```

Now the earlier example will use this parent menu item, with a priority of 0.

### Adding Custom Menu Items

Sometimes it's not enough to just customize the menu label. In this case, you
can customize the menu for the namespace within the Active Admin initializer.
```ruby
# config/initializers/active_admin.rb
config.namespace :admin do |admin|
  admin.build_menu do |menu|
    menu.add label: "Sites" do |sites|
      sites.add label: "Google",   url: "http://google.com"
      sites.add label: "Facebook", url: "http://facebook.com"
      sites.add label: "GitHub",   url: "http://github.com"
    end
  end
end
```

This block will be run once on application startup to build the menu before each
of the resources are added to it.

## Scoping the queries

If your administrators have different access levels, you may sometimes want to
scope what they have access to. Assuming your User model has the proper
has_many relationships, you can simply scope the listings and finders like so:
```ruby
ActiveAdmin.register Post do
  scope_to :current_user

  # or if the association doesn't have the default name.
  # scope_to :current_user, :association_method => :blog_posts
end
```

That approach limits the posts an admin can access to `current_user.posts`.

If you want to conditionally apply the scope, then there are options for that as well:
```ruby
ActiveAdmin.register Post do
  # Only scope the query if there is a user to scope to, helper provided via Devise
  scope_to :current_user, if: proc{ admin_user_signed_in? }

  # Don't scope the query if the user is an admin
  scope_to :current_user, unless: proc{ current_admin_user.admin? }

  # You can also combine this with a block
  scope_to if: proc{ admin_user_signed_in? } do
    User.most_popular
  end
end
```

If you want to do something fancier, for example override a default scope, you can
also use :association_method parameter with a normal method on your User model.
The only requirement is that your method returns an instance of ActiveRecord::Relation.
```ruby
class Ad < ActiveRecord::Base
  default_scope lambda { where :published => true }
end

class User < ActiveRecord::Base
  def managed_ads
    Ad.unscoped # Overrides Ad's default_scope
  end
end

ActiveAdmin.register Ad do
  scope_to :current_user, :association_method => :managed_ads
end
```

## Customizing resource retrieval

AA controllers use [Inherited Resources](https://github.com/josevalim/inherited_resources),
so you can use all the
[customization features included](https://github.com/josevalim/inherited_resources#overwriting-defaults).

Use `resource_collection` to prevent N+1 queries for an assocaited resource:
```ruby
ActiveAdmin.register Post do
  controller do
    def scoped_collection
      Post.includes :author
    end
  end
end
```

Use `resource` if you need to override the core record retrieval code:
```ruby
ActiveAdmin.register Post do
  controller do
    def resource
      Post.where(id: params[:id]).first!
    end
  end
end
```

## Belongs To

It's common to want to scope a series of resources to a relationship. For
example a Project may have many Milestones and Tickets. To nest the resource
within another, you can use the `belongs_to` method:
```ruby
ActiveAdmin.register Project

ActiveAdmin.register Ticket do
  belongs_to :project
end
```

Projects will be available as usual and tickets will be availble by visiting
`/admin/projects/1/tickets` assuming that a Project with the id of 1 exists.
Active Admin adds the child resources to a child navigation menu that only shows
up when viewing a child.

To create links to the resource, you can add them to a sidebar (one of the many
possibilities for how you may with to handle your user interface):
```ruby
ActiveAdmin.register Project do
  sidebar "Project Details" do
    ul do
      li link_to("Tickets", admin_project_tickets_path(project))
      li link_to("Milestones", admin_project_milestones_path(project))
    end
  end
end

ActiveAdmin.register Ticket do
  belongs_to :project
end

ActiveAdmin.register Milestone do
  belongs_to :project
end
```

In some cases (like Projects), there are many sub resources and you would
actually like the global navigation to switch when the user navigates "into" a
project. To accomplish this, Active Admin stores the `belongs_to` resources in a
seperate menu which you can use if you so wish. To use:
```ruby
ActiveAdmin.register Ticket do
  belongs_to :project
  navigation_menu :project
end

ActiveAdmin.register Milestone do
  belongs_to :project
  navigation_menu :project
end
```

Now, when you navigate to the tickets section, the global navigation will
only display "Tickets" and "Milestones". When you navigate back to a
non-belongs_to resource, it will switch back to the default menu.

You can also defer the menu lookup until runtime so that you can dynamically show
different menus, say perhaps on user permissions or level.  For example:
```ruby
ActiveAdmin.register Ticket do
  belongs_to: :project
  navigation_menu do
    authorized?(:manage, SomeResource) ? :project : :restricted_menu
  end
end
```
