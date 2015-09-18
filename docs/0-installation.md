# Installation

Active Admin is a Ruby Gem.

```ruby
gem 'activeadmin', '~> 1.0.0.pre1'

# Plus integrations with:
gem 'devise'
gem 'cancan' # or cancancan
gem 'draper'
gem 'pundit'
```

More accurately, it's a [Rails Engine](http://guides.rubyonrails.org/engines.html)
that can be injected into your existing Ruby on Rails application.

## Setting up Active Admin

After installing the gem, you need to run the generator. By default we use Devise, and
the generator creates an `AdminUser` model. If you want to create a different model
(or modify an existing one for use with Devise) you can pass it as an argument.
If you want to skip Devise configuration entirely, you can pass `--skip-users`.
If you're starting a new app, it would make sense to only run the second line.
Running all three of the lines below will cause conflicts so it makes sense to only choose the one that makes sense for your needs.

```sh
rails g active_admin:install              # creates the AdminUser class
rails g active_admin:install User         # creates / edits the class for use with Devise
rails g active_admin:install --skip-users # skips Devise install
```

The generator adds these core files, among others:

```
app/admin/dashboard.rb
app/assets/javascripts/active_admin.js.coffee
app/assets/stylesheets/active_admin.scss
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

If you don't already have a model that you wish to put on the dashboard, now is the time to add it using the regular Rails process. Then add it into ActiveAdmin with the following command, replacing "MyModel" with the name of your model:

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

[CHANGELOG]: https://github.com/activeadmin/activeadmin/blob/master/CHANGELOG.md
[dashboard.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
[active_admin.rb]: https://github.com/activeadmin/activeadmin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb
[read #2703]: https://github.com/activeadmin/activeadmin/issues/2703#issuecomment-38140864
