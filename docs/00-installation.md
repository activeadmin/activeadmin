# Installation

Active Admin is a Ruby Gem.

```ruby
gem 'activeadmin'
```

More accurately, it's a [Rails Engine](http://guides.rubyonrails.org/engines.html)
that can be injected into your existing Ruby on Rails application.

## Setting up Active Admin

After installing the gem, you need to run the generator (one of the following):

```sh
rails g active_admin:install              # creates the AdminUser class
rails g active_admin:install User         # uses an existing class
rails g active_admin:install --skip-users # skips user authentication entirely
```

The generator adds these core files, among others:

```
app/admin/dashboard.rb
app/assets/javascripts/active_admin.js.coffee
app/assets/stylesheets/active_admin.css.scss
config/initializers/active_admin.rb
```

Now, migrate your database and start the server:

```sh
rake db:migrate
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

This creates a file at `app/admin/my_model.rb` to set up the UI; refresh your browser to see it.

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

## simple_form

If you're getting the error `wrong number of arguments (6 for 4..5)`, [read #2703].

[CHANGELOG]: https://github.com/gregbell/active_admin/blob/master/CHANGELOG.md
[dashboard.rb]: https://github.com/gregbell/active_admin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
[active_admin.rb]: https://github.com/gregbell/active_admin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb
[read #2703]: https://github.com/gregbell/active_admin/issues/2703#issuecomment-38140864
