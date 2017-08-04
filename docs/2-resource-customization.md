---
redirect_from: /docs/2-resource-customization.html
---

# Working with Resources

Every Active Admin resource corresponds to a Rails model. So before creating a
resource you must first create a Rails model for it.

## Create a Resource

The basic command for creating a resource is `rails g active_admin:resource Post`.
The generator will produce an empty `app/admin/posts.rb` file like so:

```ruby
ActiveAdmin.register Post do
  # everything happens here :D
end
```

## Setting up Strong Parameters

Use the `permit_params` method to define which attributes may be changed:

```ruby
ActiveAdmin.register Post do
  permit_params :title, :content, :publisher_id
end
```

Any form field that sends multiple values (such as a HABTM association, or an
array attribute) needs to pass an empty array to `permit_params`:

If your HABTM is `roles`, you should permit `role_ids: []`

```ruby
ActiveAdmin.register Post do
  permit_params :title, :content, :publisher_id, role_ids: []
end
```

Nested associations in the same form also require an array, but it
needs to be filled with any attributes used.

```ruby
ActiveAdmin.register Post do
  permit_params :title, :content, :publisher_id,
    tags_attributes: [:id, :name, :description, :_destroy]
end

# Note that `accepts_nested_attributes_for` is still required:
class Post < ActiveRecord::Base
  accepts_nested_attributes_for :tags, allow_destroy: true
end
```

If you want to dynamically choose which attributes can be set, pass a block:

```ruby
ActiveAdmin.register Post do
  permit_params do
    params = [:title, :content, :publisher_id]
    params.push :author_id if current_user.admin?
    params
  end
end
```

If your resource is nested, declare `permit_params` after `belongs_to`:

```ruby
ActiveAdmin.register Post do
  belongs_to :user
  permit_params :title, :content, :publisher_id
end
```

The `permit_params` call creates a method called `permitted_params`. You should
use this method when overriding `create` or `update` actions:

```ruby
ActiveAdmin.register Post do
  controller do
    def create
      # Good
      @post = Post.new(permitted_params[:post])
      # Bad
      @post = Post.new(params[:post])

      if @post.save
        # ...
      end
    end
  end
end
```

## Disabling Actions on a Resource

All CRUD actions are enabled by default. These can be disabled for a given resource:

```ruby
ActiveAdmin.register Post do
  actions :all, except: [:update, :destroy]
end
```

## Renaming Action Items

You can use translations to override labels and page titles for actions such as
new, edit, and destroy by providing a resource specific translation.  For
example, to change 'New Offer' to 'Make an Offer' add the following in
config/locales/[en].yml:

```yaml
en:
  active_admin:
    resources:
      offer:
        new_model: 'Make an Offer'
```

## Rename the Resource

By default, any references to the resource (menu, routes, buttons, etc) in the
interface will use the name of the class. You can rename the resource by using
the `:as` option.

```ruby
ActiveAdmin.register Post, as: "Article"
```

The resource will then be available at `/admin/articles`.

## Customize the Namespace

We use the `admin` namespace by default, but you can use anything:

```ruby
# Available at /today/posts
ActiveAdmin.register Post, namespace: :today

# Available at /posts
ActiveAdmin.register Post, namespace: false
```

## Customize the Menu

The resource will be displayed in the global navigation by default. To disable
the resource from being displayed in the global navigation:

```ruby
ActiveAdmin.register Post do
  menu false
end
```

The menu method accepts a hash with the following options:

* `:label` - The string or proc label to display in the menu. If it's a proc, it
  will be called each time the menu is rendered.
* `:parent` - The string id (or label) of the parent used for this menu
* `:if` - A block or a symbol of a method to call to decide if the menu item
  should be displayed
* `:priority` - The integer value of the priority, which defaults to `10`

### Labels

To change the name of the label in the menu:

```ruby
ActiveAdmin.register Post do
  menu label: "My Posts"
end
```

If you want something more dynamic, pass a proc instead:

```ruby
ActiveAdmin.register Post do
  menu label: proc{ I18n.t "mypost" }
end
```

### Menu Priority

Menu items are sorted first by their numeric priority, then alphabetically. Since
every menu by default has a priority of `10`, the menu is normally alphabetical.

You can easily customize this:

```ruby
ActiveAdmin.register Post do
  menu priority: 1 # so it's on the very left
end
```

### Conditionally Showing / Hiding Menu Items

Menu items can be shown or hidden at runtime using the `:if` option.

```ruby
ActiveAdmin.register Post do
  menu if: proc{ current_user.can_edit_posts? }
end
```

The proc will be called in the context of the view, so you have access to all
your helpers and current user session information.

### Drop Down Menus

In many cases, a single level navigation will not be enough to manage a large
application. In that case, you can group your menu items under a parent menu item.

```ruby
ActiveAdmin.register Post do
  menu parent: "Blog"
end
```

Note that the "Blog" parent menu item doesn't even have to exist yet; it can be
dynamically generated for you.

### Customizing Parent Menu Items

All of the options given to a standard menu item are also available to
parent menu items. In the case of complex parent menu items, you should
configure them in the Active Admin initializer.

```ruby
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
```

### Dynamic Parent Menu Items

While the above works fine, what if you want a parent menu item with a dynamic
name? Well, you have to refer to it by its `:id`.

```ruby
# config/initializers/active_admin.rb
config.namespace :admin do |admin|
  admin.build_menu do |menu|
    menu.add id: 'blog', label: proc{"Something dynamic"}, priority: 0
  end
end

# app/admin/post.rb
ActiveAdmin.register Post do
  menu parent: 'blog'
end
```

### Adding Custom Menu Items

Sometimes it's not enough to just customize the menu label. In this case, you
can customize the menu for the namespace within the Active Admin initializer.

```ruby
# config/initializers/active_admin.rb
config.namespace :admin do |admin|
  admin.build_menu do |menu|
    menu.add label: "The Application", url: "/", priority: 0

    menu.add label: "Sites" do |sites|
      sites.add label: "Google",
                url: "http://google.com",
                html_options: { target: :blank }

      sites.add label: "Facebook",
                url: "http://facebook.com"

      sites.add label: "Github",
                url: "http://github.com"
    end
  end
end
```

This will be registered on application start before your resources are loaded.

## Scoping the queries

If your administrators have different access levels, you may sometimes want to
scope what they have access to. Assuming your User model has the proper
has_many relationships, you can simply scope the listings and finders like so:

```ruby
ActiveAdmin.register Post do
  scope_to :current_user # limits the accessible posts to `current_user.posts`

  # Or if the association doesn't have the default name:
  scope_to :current_user, association_method: :blog_posts

  # Finally, you can pass a block to be called:
  scope_to do
    User.most_popular_posts
  end
end
```

You can also conditionally apply the scope:

```ruby
ActiveAdmin.register Post do
  scope_to :current_user, if:     proc{ current_user.limited_access? }
  scope_to :current_user, unless: proc{ current_user.admin? }
end
```

## Eager loading

A common way to increase page performance is to elimate N+1 queries by eager
loading associations:

```ruby
ActiveAdmin.register Post do
  includes :author, :categories
end
```

## Customizing resource retrieval

Our controllers are built on [Inherited
Resources](https://github.com/activeadmin/inherited_resources), so you can use
[all of its
features](https://github.com/activeadmin/inherited_resources#overwriting-defaults).

If you need to customize the collection properties, you can overwrite the
`scoped_collection` method.

```ruby
ActiveAdmin.register Post do
  controller do
    def scoped_collection
      end_of_association_chain.where(visibility: true)
    end
  end
end
```

If you need to completely replace the record retrieving code (e.g., you have a
custom `to_param` implementation in your models), override the `resource` method
on the controller:

```ruby
ActiveAdmin.register Post do
  controller do
    def find_resource
      scoped_collection.where(id: params[:id]).first!
    end
  end
end
```

Note that if you use an authorization library like CanCan, you should be careful
to not write code like this, otherwise **your authorization rules won't be
applied**:

```ruby
ActiveAdmin.register Post do
  controller do
    def find_resource
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

Projects will be available as usual and tickets will be available by visiting
`/admin/projects/1/tickets` assuming that a Project with the id of 1 exists.
Active Admin does not add "Tickets" to the global navigation because the routes
can only be generated when there is a project id.

To create links to the resource, you can add them to a sidebar (one of the many
possibilities for how you may with to handle your user interface):

```ruby
ActiveAdmin.register Project do

  sidebar "Project Details", only: [:show, :edit] do
    ul do
      li link_to "Tickets",    admin_project_tickets_path(resource)
      li link_to "Milestones", admin_project_milestones_path(resource)
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
separate menu which you can use if you so wish. To use:

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
different menus, say perhaps based on user permissions. For example:

```ruby
ActiveAdmin.register Ticket do
  belongs_to :project
  navigation_menu do
    authorized?(:manage, SomeResource) ? :project : :restricted_menu
  end
end
```

If you still want your `belongs_to` resources to be available in the default menu
and through non-nested routes, you can use the `:optional` option. For example:

```ruby
ActiveAdmin.register Ticket do
  belongs_to :project, optional: true
end
```
