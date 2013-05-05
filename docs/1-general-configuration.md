# General Configuration

Active Admin generates an initializer to hold site-wide configuration settings.
Below are the most commonly changed settings.

## Authentication

Set the controller method for user authentication:
```ruby
# Defaults to :authenticate_admin_user!
config.authentication_method = :authenticate_user!
```

Set the method to call within the view to access the current admin user
```ruby
# Defaults to :current_admin_user
config.current_user_method = :current_user
```

Both of these settings can be set to false to turn off authentication.
```ruby
config.authentication_method = false
config.current_user_method   = false
```

## Site Title Options

```ruby
config.site_title       = "My Admin Site" # Defaults to the name of your application
config.site_title_link  = "/"             # Defaults to not have a link at all
config.site_title_image = "site_logo.png" # Must be in the /public folder of your app
```

## Internationalization (I18n)

To customize existing translations, see the existing files in `config/locales`
in the Active Admin source code. If something is inaccurate or missing, please
feel free to open an Issue on GitHub.

## Namespaces

When registering resources in Active Admin, they are loaded into a namespace.
The default namespace is "admin".
```ruby
# app/admin/post.rb
ActiveAdmin.register Post do
  # ...
end
```

The Post resource will be loaded into the "admin" namespace and will be
available at `/admin/posts`. Each namespace holds on to its own configuration
settings which inherit from the application's general configurations.

For example, if you want to have different site titles for for each namespace,
you can use the `config.namespace` block within the initializer to configure them
individually.
```ruby
config.site_title = "My Default Site Title"

config.namespace :admin do |admin|
  admin.site_title = "Admin Site"
end

config.namespace :super_admin do |super_admin|
  super_admin.site_title = "Super Admin Site"
end
```

Each setting available in the Active Admin setup block is configurable on a per
namespace basis.

## Load paths

By default Active Admin files go under '/app/admin'. You can change this
directory in the initializer file:
```ruby
config.load_paths = [File.join(Rails.root, "app", "ui")]
```

## Comments

Active Admin has a built-in commenting system, but you can easily disable it.
```ruby
# For the entire application:
config.allow_comments = false
# For a single namespace:
config.namespace :foo do |c|
  c.allow_comments = false
end
# For a single resource: (inside app/admin/post.rb)
ActiveAdmin.register Post do
  config.allow_comments = false
end
```

## Utility Navigation

The "utility navigation" shown at the top right when logged in by default shows
the current user email address and a link to log out.  However, the utility
navigation is just like any other menu in the system, so you can provide your
own menu to be rendered in place if you like.

```ruby
config.build_menu :utility_navigation do |menu|
  menu.add label: "ActiveAdmin.info",
           url:   "http://www.activeadmin.info",
           html_options: { target: :blank }
  config.add_logout_button_to_menu menu
end
```
