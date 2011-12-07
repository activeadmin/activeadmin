# General Configuration

Active Admin generates an initializer for you with sane defaults. The
initializer can be found at `config/initializers/active_admin.rb`. For the most
part, it is well documented. Here are a few common configurations.

## Authentication

Active Admin requires two settings to authenticate and use the current user
within your application. Both are set in `config/initializers/active_admin.rb`.
By default they are setup for use with Devise and a model named AdminUser. If
you chose a different model name, you will need to update these settings.

Set the method that controllers should call to authenticate the current user
with:

    # config/initializers/active_admin.rb
    config.authentication_method = :authenticate_admin_user!

Set the method to call within the view to access the current admin user

    # config/initializers/active_admin.rb
    config.current_user_method = :current_admin_user

Both of these settings can be set to false to turn off authentication.

    # Turn off authentication all together
    config.authentication_method = false
    config.current_user_method   = false

## Site Title Options

You can update the title or use an optional image in the initializer also. In addition you can set the link.  By default
there is no link and the title is set to the name of your Rails.application class name.

    # config/initializers/active_admin.rb
    config.site_title = "My Admin Site"
    config.site_title_link = "/"    ## Rails url helpers do not work here
    config.site_title_image = "site_log_image.png"

## Internationalization (I18n)

To internationalize Active Admin or to change default strings, you can copy
`lib/active_admin/locales/en.yml` to your application `config/locales` directory and
change its content. You can contribute to the project with your translations too!

## Namespaces

When registering resources in Active Admin, they are loaded into a namespace.
The default namespace is "admin".

    # app/admin/posts.rb
    ActiveAdmin.register Post do
      # ...
    end

The Post resource will be loaded into the "admin" namespace and will be
available at `/admin/posts`. Each namespace holds on to its own configuration
settings which inherit from the application's general configurations.

For example, if you have two namespaces: `:admin` and `super_admin` and want to
have different site title's for each namespace. You can use the
`config.namespace(name)` block within the initializer file to configure them
individually.

    ActiveAdmin.setup do |config|
      config.site_title = "My Default Site Title"

      config.namespace :admin do |admin|
        admin.site_title = "Admin Site"
      end

      config.namespace :super_admin do |super_admin|
        super_admin.site_title = "Super Admin Site"
      end
    end

Each setting available in the Active Admin setup block is configurable on a per
namespace basis.
