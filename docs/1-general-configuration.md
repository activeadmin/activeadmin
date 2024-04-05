---
redirect_from: /docs/1-general-configuration.html
---

# General Configuration

You can configure Active Admin settings in `config/initializers/active_admin.rb`.
Here are a few common configurations:

## Authentication

Active Admin requires two settings to authenticate and use the current user
within your application.

+ the method controllers used to force authentication

```ruby
config.authentication_method = :authenticate_admin_user!
```

+ the method used to access the current user

```ruby
config.current_user_method = :current_admin_user
```

Both of these settings can be set to false to turn off authentication.

```ruby
config.authentication_method = false
config.current_user_method   = false
```

## Site Title Options

Every page has what's called the site title on the left side of the menu bar.
If you want, you can customize it.

```ruby
config.site_title       = "My Admin Site"
config.site_title_link  = "/"
config.site_title_image = "site_image.png"
config.site_title_image = "http://www.google.com/images/logos/google_logo_41.png"
config.site_title_image = ->(context) { context.current_user.company.logo_url }
```

## Internationalization (I18n)

Active Admin comes with translations for a lot of
[locales](https://github.com/activeadmin/activeadmin/blob/master/config/locales/).
Active Admin does not provide the translations for the kaminari gem it uses for pagination,
to get these you can use the
[kaminari-i18n](https://github.com/tigrish/kaminari-i18n) gem.

To translate Active Admin to a new language or customize an existing
translation, you can copy
[config/locales/en.yml](https://github.com/activeadmin/activeadmin/blob/master/config/locales/en.yml)
to your application's `config/locales` folder and update it. We welcome
new/updated translations, so feel free to
[contribute](https://github.com/activeadmin/activeadmin/blob/master/CONTRIBUTING.md)!

When using [devise](https://github.com/plataformatec/devise) for authentication,
you can use the [devise-i18n](https://github.com/tigrish/devise-i18n)
gem to get the devise translations for other locales.

## Localize Format For Dates and Times

Active Admin sets `:long` as default localize format for dates and times.
If you want, you can customize it.

```ruby
config.localize_format = :short
```

## Namespaces

When registering resources in Active Admin, they are loaded into a namespace.
The default namespace is "admin".

```ruby
# app/admin/posts.rb
ActiveAdmin.register Post do
  # ...
end
```

The Post resource will be loaded into the "admin" namespace and will be
available at `/admin/posts`. Each namespace holds on to its own settings that
inherit from the application's configuration.

For example, if you have two namespaces (`:admin` and `:super_admin`) and want to
have different site title's for each, you can use the `config.namespace(name)`
block within the initializer file to configure them individually.

```ruby
ActiveAdmin.setup do |config|
  config.site_title = "My Default Site Title"

  config.namespace :admin do |admin|
    admin.site_title = "Admin Site"
  end

  config.namespace :super_admin do |super_admin|
    super_admin.site_title = "Super Admin Site"
  end
end
```

If you are creating a multi-tenant application you may want to have multiple namespaces mounted to the same path. We can do this using the `route_options` settings on the namespace

```ruby
config.namespace :site_1 do |admin|
  admin.route_options = { path: :admin, constraints: ->(request){ request.domain == "site1.com" } }
end

config.namespace :site_2 do |admin|
  admin.route_options = { path: :admin, constraints: ->(request){ request.domain == "site2.com" } }
end
```

If you would like to mount the namespace to a subdomain instead of path we can use the `route_options` for this as well

```ruby
config.namespace :admin do |admin|
  admin.route_options = { path: '', subdomain: 'admin' }
end
```

Each setting available in the Active Admin setup block is configurable on a per
namespace basis.

## Load paths

By default Active Admin files go inside `app/admin/`. You can change this
directory in the initializer file:

```ruby
ActiveAdmin.setup do |config|
  config.load_paths = [File.join(Rails.root, "app", "ui")]
end
```

## Comments

By default Active Admin includes comments on resources. Sometimes, this is
undesired. To disable comments:

```ruby
# For the entire application:
ActiveAdmin.setup do |config|
  config.comments = false
end

# For a namespace:
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.comments = false
  end
end

# For a given resource:
ActiveAdmin.register Post do
  config.comments = false
end
```

You can change the name under which comments are registered:

```ruby
config.comments_registration_name = 'AdminComment'
```

You can change the order for the comments and you can change the column to be
used for ordering:

```ruby
config.comments_order = 'created_at ASC'
```

You can disable the menu item for the comments index page:

```ruby
config.comments_menu = false
```

You can customize the comment menu:

```ruby
config.comments_menu = { parent: 'Admin', priority: 1 }
```

Remember to indicate where to place the comments and form with:

```ruby
active_admin_comments
```

## Utility Navigation

The "utility navigation" shown at the top right normally shows the current user
and a link to log out. However, the utility navigation is just like any other
menu in the system; you can provide your own menu to be rendered in its place.

```ruby
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.build_menu :utility_navigation do |menu|
      menu.add label: "ActiveAdmin.info", url: "http://www.activeadmin.info",
                                          html_options: { target: "_blank" }
      admin.add_current_user_to_menu  menu
      admin.add_logout_button_to_menu menu
    end
  end
end
```

## Footer Customization

By default, Active Admin displays a "Powered by ActiveAdmin" message on every
page. You can override this message and show domain-specific messaging:

```ruby
config.footer = "MyApp Revision v1.3"
```
