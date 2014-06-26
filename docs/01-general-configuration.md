# General Configuration

You can configure Active Admin settings in `config/initializers/active_admin.rb`.
Here are a few common configurations:

## Authentication

Active Admin requires two settings to authenticate and use the current user
within your application.

+ the method controllers use to force authentication

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
```

## Internationalization (I18n)

To translate Active Admin to a new language or customize an existing translation, you can copy
[config/locales/en.yml](https://github.com/gregbell/active_admin/blob/master/config/locales/en.yml)
to your application's `config/locales` folder and update it. We welcome new/updated translations,
so feel free to [contribute!](https://github.com/gregbell/active_admin/blob/master/CONTRIBUTING.md)

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
  config.allow_comments = false
end

# For a namespace:
ActiveAdmin.setup do |config|
  config.namespace :admin do |admin|
    admin.allow_comments = false
  end
end

# For a given resource:
ActiveAdmin.register Post do
  config.comments = false
end
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
                                          html_options: { target: :blank }
      admin.add_current_user_to_menu  menu
      admin.add_logout_button_to_menu menu
    end
  end
end
```
