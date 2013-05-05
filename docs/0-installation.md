# Install

## Gemfile

First add the gem to your Gemfile:
```ruby
gem 'activeadmin'
```

## Initialize Active Admin

Use the command below to initialize Active Admin. It would also create a user
model named AdminUser.
```sh
rails generate active_admin:install
```

To create a user model with a different name, pass it as the last parameter:
```sh
rails generate active_admin:install User
```

You could also skip the creation of this user model. But in that case you
need to make additional changes in `config/intializers/active_admin.rb`.
```sh
rails generate active_admin:install --skip-users
```

After the generator finishes, you need to migrate the database:
```sh
rake db:migrate
```

## Register your models with Active Admin

This creates a file in `app/admin/` to hold any resource-specific configuration.
```sh
rails generate active_admin:resource Post
```

# Upgrade

To upgrade Active Admin, simply update the version number in your Gemfile, then
run the assets generator:
```sh
rails generate active_admin:assets
```

This ensures that your Active Admin assets are up to date. You should run this
command each time you updgrade to a new version.

# Gem compatibility

## will_paginate compatibility

If you use `will_paginate` in your app, you need to configure an initializer for
Kaminari to avoid conflicts. Put this in `config/initializers/kaminari.rb`

```ruby
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
```
