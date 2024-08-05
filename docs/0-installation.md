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

More accurately, it's a [Rails Engine](https://guides.rubyonrails.org/engines.html)
that can be injected into your existing Ruby on Rails application.

## Setting up Active Admin

After installing the gem, you need to run the generator. Here are your options:

* If you don't want to use Devise, run it with `--skip-users`:

  ```sh
  rails g active_admin:install --skip-users
  ```

* If you want to customize the name of the generated user class, or if you want to use an existing user class, provide the class name as an argument:

  ```sh
  rails g active_admin:install User
  ```

* Otherwise, with no arguments we will create an `AdminUser` class to use with Devise:

  ```sh
  rails g active_admin:install
  ```

The generator adds these core files, among others:

* `app/admin/dashboard.rb`
* `app/assets/stylesheets/active_admin.css`
* `config/initializers/active_admin.rb`
* `tailwind-active_admin.config.js`

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
rails generate active_admin:resource Post
```

This creates a `app/admin/post.rb` file with some content to start. Preview
any changes in your browser.

# Upgrading

When upgrading to a new version, it's a good idea to check the [CHANGELOG].

To update the assets:

```sh
rails generate active_admin:assets
```

You should also sync these files with their counterparts in the AA source code:

* app/admin/dashboard.rb [~>][dashboard.rb]
* config/initializers/active_admin.rb [~>][active_admin.rb]

Along with any template partials you've copied and modified.

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

[CHANGELOG]: https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md
[dashboard.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
[active_admin.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb
[read #2703]: https://github.com/activeadmin/activeadmin/issues/2703#issuecomment-38140864
