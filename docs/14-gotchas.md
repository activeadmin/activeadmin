# Gotchas

## Security

### Spreadsheet applications vulnerable to unescaped CSV data

If your CSV export includes untrusted data from users, that data may contain an
executable formula that can call arbitrary commands on your computer. See
[#4256](https://github.com/activeadmin/activeadmin/issues/4256) for more
details.

## Session Commits & Asset Pipeline

When you configure the asset pipeline, make sure the asset prefix
(`config.assets.prefix`) differs from the ActiveAdmin namespace (the default is
`/admin`). If they match, Sprockets will not commit the session. Flash messages
will not work, and the session cannot store data.

For more information see [the following
post](https://www.mobomo.com/2013/03/rails-assets-prefix-may-disable-your-session/).

## Helpers

### Helpers may not be included by default

If you set `config.action_controller.include_all_helpers = false` in your
application configuration, include the helper manually.

#### Solutions

##### Use an override

This applies to all ActiveAdmin resources. Follow the [Rails guidelines for
overriding](https://guides.rubyonrails.org/engines.html#improving-engine-functionality)
to use this safely with Zeitwerk.

```ruby
ActiveAdmin::BaseController.class_eval do
  helper ApplicationHelper
end
```

##### Use the `controller` method

This applies to one resource at a time.

```ruby
ActiveAdmin.register User do
  controller do
    helper UserHelper
  end
end
```

## CSS

To prevent ActiveAdmin styles from overriding your application styles, remove
the `require_tree` command from the application's CSS file that includes
`active_admin.scss` in its tree.

## Deprecation warnings with modern sass build tools

Active Admin v3's SCSS is written for [sassc](https://rubygems.org/gems/sassc), which follows an older version of the SCSS specification. If you use a Node-based build system like esbuild, webpacker, or vite, you may encounter deprecation warnings for color functions like this when compiling assets:

> DEPRECATION WARNING: lighten() is deprecated

As a quick workaround, you may be able to silence these warnings by passing the `quietDeps` scss compilation option in your build system. With vite, follow these instructions: <https://github.com/vitejs/vite/discussions/4013#discussioncomment-10793687> (note this requires installing the `sass-embedded` dependency).

## Conflicts

### With gems that provides a `search` class method on a model

If a gem defines a `search` class method on a model, it can conflict with the
method provided by `ransack`, a dependency of ActiveAdmin.

Use the solution for the gem that defines the conflicting method:

#### `tire`, `retire` and `elasticsearch-rails`

Call the gem's `search` method explicitly:

##### For `tire` and `retire`

```ruby
YourModel.tire.search
```

##### For `elasticsearch-rails`

```ruby
YourModel.__elasticsearch__.search
```

### Sunspot Solr

```ruby
YourModel.solr_search
```

## Authentication & Application Controller

`ActiveAdmin::BaseController` inherits from `ApplicationController`. The
authentication callbacks in `ApplicationController` run instead of the
authentication method in the Active Admin configuration file. For example, if
`ApplicationController` has a `before_action :custom_authentication_method`
callback and the configuration sets
`config.authentication_method = :authenticate_active_admin_user`, then
`custom_authentication_method` runs instead of
`authenticate_active_admin_user`.
