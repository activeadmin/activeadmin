---
redirect_from: /docs/documentation.html
---
<h2 class="in-docs">
    <span class="breadcrumb">
        <a href="documentation.html">Documentation</a> :
    </span>
    Active Admin Documentation
</h2>

Active Admin is a framework for creating administration style interfaces. It abstracts common business application patterns to make it simple for developers to implement beautiful and elegant interfaces with very
little effort.

### Getting Started

Active Admin is released as a Ruby Gem. The gem is to be installed within a Ruby on Rails 4 application. To
        install, simply add the following to your Gemfile:</p>

```ruby
# Gemfile
gem 'activeadmin', github: 'activeadmin'
```

After updating your bundle, run the installer

```bash
rails generate active_admin:install
```

The installer creates an initializer used for configuring defaults used by Active Admin as well as a new folder at <tt>app/admin</tt> to put all your admin configurations.

Migrate your db and start the server:

```bash
$> rake db:migrate
$> rails server
```

Visit http://localhost:3000/admin and log in using:

* <em>User</em>: admin@example.com
* <em>Password</em>: password

Voila! You&#8217;re on your brand new Active Admin dashboard.

To register your first model, run:

```bash
$> rails generate active_admin:resource
        [MyModelName]
```

This creates a file at <tt>app/admin/my_model_names.rb</tt> for configuring the resource. Refresh your web browser to see the interface.</p>

### Next Steps

Now that you have a working Active Admin installation, learn how to customize it:

* <a href='{{ site.baseurl }}/3-index-pages.html'>Customize the Index Page</a>
* <a href='{{ site.baseurl }}/5-forms.html'>Customize the New and Edit Form</a>
* <a href='{{ site.baseurl }}/6-show-pages.html'>Customize the Show Page</a>
* <a href='{{ site.baseurl }}/2-resource-customization.html'>Customize the Resource in General</a>
