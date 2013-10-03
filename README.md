# Active Admin

Active Admin is a Ruby on Rails framework for creating elegant backends for website administration.

[![](https://api.travis-ci.org/gregbell/active_admin.png)](http://travis-ci.org/gregbell/active_admin)
[![](https://codeclimate.com/github/gregbell/active_admin.png)](https://codeclimate.com/github/gregbell/active_admin)
[![](https://gemnasium.com/gregbell/active_admin.png)](https://gemnasium.com/gregbell/active_admin)
[![](https://coveralls.io/repos/gregbell/active_admin/badge.png)](https://coveralls.io/r/gregbell/active_admin)
[![](http://badgr.co/gittip/activeadmin.png)](https://www.gittip.com/activeadmin)

## Documentation & Support

* Guides: <http://activeadmin.info/documentation.html>
* Documentation: <http://rubydoc.info/gems/activeadmin/frames>
* Wiki: <https://github.com/gregbell/active_admin/wiki>
* Live demo: <http://demo.activeadmin.info/admin>
* Website: <http://www.activeadmin.info>
* __Need Support?__ Ask the mailing list: <http://groups.google.com/group/activeadmin>

## Goals

1. Allow developers to quickly create gorgeous administration interfaces __(Not Just CRUD)__
2. Build a DSL for developers and an interface for businesses.
3. Ensure that developers can easily customize every nook and cranny of the interface.
4. Build common interfaces as shareable gems so that the entire community benefits.

## Getting Started

Active Admin is a Ruby Gem.

```ruby
gem 'activeadmin'
```

More accurately, it's a [Rails Engine](http://guides.rubyonrails.org/engines.html)
that can be injected into your existing Ruby on Rails application.

```sh
rails generate active_admin:install
```

The generator adds these core files, among others:

```
app/admin/dashboard.rb
app/assets/javascripts/active_admin.js.coffee
app/assets/stylesheets/active_admin.css.scss
config/initializers/active_admin.rb
```

Migrate your database and start the server:

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

## Upgrading

When upgrading to a new version, it's a good idea to check the [CHANGELOG].

To update the JS & CSS assets:

```sh
rails generate active_admin:assets
```

You should also sync these files with their counterparts in the AA source code:

* app/admin/dashboard.rb [~>][dashboard.rb]
* config/initializers/active_admin.rb [~>][active_admin.rb]

## Dependencies

We try not to reinvent the wheel, so Active Admin is built using many other open source projects:

Tool                  | Description
--------------------- | -----------
[Inherited Resources] | Simplifies controllers with pre-built RESTful controller actions
[Formtastic]          | A Rails form builder plugin with semantically rich and accessible markup
[Devise]              | Powerful, extensible user authentication
[Iconic Icons]        | An excellent SVG icon set designed by P.J. Onori

[CHANGELOG]: https://github.com/gregbell/active_admin/blob/master/CHANGELOG.md
[dashboard.rb]: https://github.com/gregbell/active_admin/blob/master/lib/generators/active_admin/install/templates/dashboard.rb
[active_admin.rb]: https://github.com/gregbell/active_admin/blob/master/lib/generators/active_admin/install/templates/active_admin.rb.erb

[Inherited Resources]: https://github.com/josevalim/inherited_resources
[Formtastic]: https://github.com/justinfrench/formtastic
[Devise]: https://github.com/plataformatec/devise
[Iconic Icons]: http://somerandomdude.com/projects/iconic

