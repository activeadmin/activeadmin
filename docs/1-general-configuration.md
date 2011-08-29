# General Configuration

Below are some common settings you'll find in
`config/initializers/active_admin.rb`.

## Authentication

Active Admin requires two settings to authenticate and use the current user
within your application. Both are set in
<tt>config/initializers/active_admin.rb</tt>. By default they are setup for use
with Devise and a model named AdminUser. If you chose a different model name,
you will need to update these settings.

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

## Site Title

You can update the title used for the site in the initializer also. By default
it is set to the name of your Rails.application class name.

    # config/initializers/active_admin.rb
    config.site_title = "My Admin Site"

## Internationalization (I18n)

To internationalize Active Admin or to change default strings, you can copy
lib/active_admin/locales/en.yml to your application config/locales directory and
change its content. You can contribute to the project with your translations too!
