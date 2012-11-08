# Installation

Installing Active Admin in a Rails application is as easy as adding the gem to
your Gemfile:

    # Gemfile
    gem 'activeadmin'

## Running the Generator

Once you have added the gem to your Gemfile (and any other dependencies), you
need to run the Active Admin install generator.

    $> rails generate active_admin:install

This will install Active Admin the default settings. By default it will create a
new Devise user / model called AdminUser. To change the name of the user class,
simply pass the class as the last argument:

    $> rails generate active_admin:install User

Instead of generating an AdminUser class, this command will create a User class.

You can skip the Devise user class all together by using the `skip-users` flag:

    $> rails generate active_admin:install --skip-users

NOTE: If you don't use the default user settings, you will need to configure the
settings in `config/intializers/active_admin.rb` to suite your needs.

After running the installer, run `rake db:migrate` to ensure that all db tables
are created.

## Upgrading

To upgrade Active Admin, simply update the version number in your Gemfile, then
run the assets generator:

    $> rails generate active_admin:assets

This command makes sure you have all the latest assets and your installation is
up to date. Each time you upgrade Active Admin, you should run this command.

## will_paginate compatibility

If you use `will_paginate` in your app, you need to configure an initializer for
Kaminari to avoid conflicts. Put this in `config/initializers/kaminari.rb`


    Kaminari.configure do |config|
      config.page_method_name = :per_page_kaminari
    end
