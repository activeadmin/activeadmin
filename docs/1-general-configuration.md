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
config.site_title = "My Admin Site"
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

## JavaScript modules

Active Admin pages use their own import map, `ActiveAdmin.importmap`, and import
only its `active_admin` entry point. A module pinned in your app's
`config/importmap.rb` is not loaded on Active Admin pages.

To add a module to every Active Admin page, pin it into `ActiveAdmin.importmap`
and list it in `javascript_modules`. Active Admin imports these modules after
`active_admin`, in order:

```ruby
# config/initializers/active_admin.rb
ActiveAdmin.importmap.pin "admin/extras", to: "admin/extras.js"

ActiveAdmin.setup do |config|
  config.javascript_modules << "admin/extras"
end
```

Append to `javascript_modules` with `<<`. Assigning a new list drops the
modules that engines added before your initializer ran.

An engine pins its modules from an initializer that runs after Active Admin
draws its import map:

```ruby
initializer "my_engine.active_admin", after: "active_admin.importmap" do |app|
  next unless app.config.respond_to?(:importmap)

  ActiveAdmin.importmap.draw(root.join("config/importmap.rb"))
  app.config.assets.paths << root.join("app/javascript")
  ActiveAdmin.application.javascript_modules << "my_engine/index"
  ActiveAdmin.application.importmap_watches << root.join("app/javascript")
end
```

If the engine vendors JavaScript packages, add its `vendor/javascript` directory
to `app.config.assets.paths` as well. Propshaft serves only files in the asset
paths.

In development and test, Active Admin clears its import map cache when a file in
one of the `importmap_watches` directories changes. The list starts with Active
Admin's own `app/javascript`. Rails does not watch directories inside installed
gems, so an engine's entry takes effect only while the engine is loaded from a
path, such as an engine inside your app or a `path:` gem. When you pin modules
from your app, add your directory so that edits to those modules reach the
browser without a restart. Active Admin reads the list once, after all
initializers have run, and raises an error if you append to it later. Append to
it from an initializer, not from a `to_prepare` or `after_initialize` block:

```ruby
ActiveAdmin.setup do |config|
  config.importmap_watches << Rails.root.join("app/javascript")
end
```

## Comments

By default Active Admin includes comments on resources. To disable comments:

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
active_admin_comments_for(resource)
```
