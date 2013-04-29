# Install

## Gemfile

First add the gem to your Gemfile:

    gem 'activeadmin'

## Initialize Active Admin

Use the command below to initialize Active Admin. It would also create a user model 
 named AdminUser.

    $> rails generate active_admin:install

To create a user model with a different name, pass it as the last parameter:

    $> rails generate active_admin:install User

You could also skip the creation of this user model. But note that in this case, you
 need to make additional changes in `config/intializers/active_admin.rb`.

    $> rails generate active_admin:install --skip-users

After the generator finishes, you need to migrate the database:

    $> rake db:migrate

## Register your models with Active Admin

This creates a file in `app/admin/` to hold any resource-specific configuration.

    $> rails generate active_admin:resource Post

# Upgrade

To upgrade Active Admin, simply update the version number in your Gemfile, then
run the assets generator:

    $> rails generate active_admin:assets

This command makes sure you have all the latest assets and your installation is
up to date. Each time you upgrade Active Admin, you should run this command.


# Gem compatibility

## will_paginate compatibility

If you use `will_paginate` in your app, you need to configure an initializer for
Kaminari to avoid conflicts. Put this in `config/initializers/kaminari.rb`


    Kaminari.configure do |config|
      config.page_method_name = :per_page_kaminari
    end
