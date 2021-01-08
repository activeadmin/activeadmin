---
redirect_from: /docs/0-installation.html
---

# Installation

Active Admin is a Ruby Gem.

```ruby
gem 'activeadmin'

# Plus integrations with:
gem 'devise'
gem 'cancancan'
gem 'draper'
gem 'pundit'
```

More accurately, it's a [Rails Engine](http://guides.rubyonrails.org/engines.html)
that can be injected into your existing Ruby on Rails application.

## Setting up Active Admin

After installing the gem, you need to run the generator. It will check with you
things like whether you want to use Devise or not and the name of the User class.

  ```sh
  rails g active_admin:install
  ```

If you don't want this interaction, run it with `--no_interaction` and we will use
default values and create an `AdminUser` class to use with Devise

  ```sh
  rails g active_admin:install --no_interaction
  ```

Here are your other options and they all skip their respective interactive questions:

* If you don't want to use Devise, run it with `--skip-users`:

  ```sh
  rails g active_admin:install --skip-users
  ```

* If you want to use an existing user class, provide it as an argument:

  ```sh
  rails g active_admin:install User
  ```

The generator adds these core files, among others:

* `app/admin/dashboard.rb`
* `app/assets/javascripts/active_admin.js`
* `app/assets/stylesheets/active_admin.scss`
* `config/initializers/active_admin.rb`

Now, migrate and seed your database before starting the server:

```sh
rails db:migrate
rails db:seed
rails server
```

Visit `http://localhost:3000/admin` and log in as the default user:

* __User__: admin@example.com
* __Password__: password

Voila! You're on your brand new Active Admin dashboard.

To register an existing model with Active Admin:

```sh
rails generate active_admin:resource MyModel
```

This creates a file at `app/admin/my_model.rb` to set up the UI; refresh your
browser to see it.

# Upgrading

When upgrading to a new version, it's a good idea to check the [CHANGELOG].

To update the JS & CSS assets:

```sh
rails generate active_admin:assets
```

You should also sync these files with their counterparts in the AA source code:

* app/admin/dashboard.rb [~>][dashboard.rb]
* config/initializers/active_admin.rb [~>][active_admin.rb]

# Gem compatibility

## will_paginate

If you use `will_paginate` in your app, you need to configure an initializer for
Kaminari to avoid conflicts.

```ruby
# config/initializers/kaminari.rb
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
```

If you are also using [Draper](https://github.com/drapergem/draper), you may
want to make sure `per_page_kaminari` is delegated correctly:

```ruby
Draper::CollectionDecorator.send :delegate, :per_page_kaminari
```

## simple_form

If you're getting the error `wrong number of arguments (6 for 4..5)`, [read #2703].

## webpacker

For new apps starting with Rails 6.0, Webpacker has become the default asset generator. You can **opt-in to using Webpacker for ActiveAdmin assets** as well by updating your configuration to turn on the `use_webpacker` option, either at installation time or manually.

* at active_admin installation:

  ```sh
  rails g active_admin:install --use_webpacker
  ```

* manually:

  ```ruby
  ActiveAdmin.setup do |config|
    config.use_webpacker = true
  end
  ```

  And run the generator to get default Active Admin assets:

  ```sh
  rails g active_admin:webpacker
  ```

[CHANGELOG]: https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md
[dashboard.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
[active_admin.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb
[read #2703]: https://github.com/activeadmin/activeadmin/issues/2703#issuecomment-38140864
