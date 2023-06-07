---
redirect_from: /docs/documentation.html
---

Active Admin is a framework for creating administration style interfaces. It
abstracts common business application patterns to make it simple for developers
to implement beautiful and elegant interfaces with very little effort.

# Getting Started

Active Admin is released as a Ruby Gem. The gem is to be installed within a Ruby
on Rails application. To install, simply add the following to your Gemfile:

```ruby
# Gemfile
gem 'activeadmin'
```

After updating your bundle, run the installer

```bash
rails generate active_admin:install
```

The installer creates an initializer used for configuring defaults used by
Active Admin as well as a new folder at `app/admin` to put all your admin
configurations.

Migrate your db and start the server:

```bash
$> rails db:migrate
$> rails server
```

Visit `http://localhost:3000/admin` and log in using:

* __User__: admin@example.com
* __Password__: password

Voila! You&#8217;re on your brand new Active Admin dashboard.

To register your first model, run:

```bash
$> rails generate active_admin:resource
        [MyModelName]
```

This creates a file at `app/admin/my_model_names.rb` for configuring the
resource. Refresh your web browser to see the interface.

# Next Steps

Now that you have a working Active Admin installation, learn how to customize it:

* [Customize the Index Page](3-index-pages.md)
* [Customize the New and Edit Form](5-forms.md)
* [Customize the Show Page](6-show-pages.md)
* [Customize the Resource in General](2-resource-customization.md)
