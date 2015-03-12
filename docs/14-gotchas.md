#Gotchas

## Session Commits & Asset Pipeline

When configuring the asset pipeline ensure that the asset prefix 
(`config.assets.prefix`) is not the same as the namespace of ActiveAdmin 
(default namespace is `/admin`). If they are the same Sprockets will prevent the 
session from being committed. Flash messages won't work and you will be unable to 
use the session for storing anything.

For more information see the following post: 
[http://www.intridea.com/blog/2013/3/20/rails-assets-prefix-may-disable-your-session](http://www.intridea.com/blog/2013/3/20/rails-assets-prefix-may-disable-your-session)

## Helpers

There are two knowing gotchas with helpers. This hopefully will help you to
find a solution.

### Helpers are not reloading in development

This is a known and still open [issue](https://github.com/activeadmin/activeadmin/issues/697)
the only way is to restart your server each time you change a helper.

### Helper maybe not included by default

If you use `config.action_controller.include_all_helpers = false` in your application config, 
you need to include it by hand.

#### Solutions

##### First use a monkey patch

This works for all ActiveAdmin resources at once.

```ruby
# config/initializers/active_admin_helpers.rb
ActiveAdmin::BaseController.class_eval do
  helper ApplicationHelper
end
```

##### Second use the `controller` method

This works only for one resource at a time.

```ruby
ActiveAdmin.register User do
  controller do
    helper UserHelper
  end
end
```

## CSS

In order to avoid the override of your application style with the Active Admin one, you can do one of this things:
* You can properly move the generated file `active_admin.css.scss` from `app/assets/stylesheets` to `vendor/assets/stylesheets`.
* You can remove all `require_tree` comands from your root level css files, where the `active_admin.css.scss` is in the tree.

## Conflicts

### With gems that provides a `search` class method on a model

If a gem defines a `search` class method on a model, this can result in conflicts 
with the same method provided by `ransack` (a dependency of ActiveAdmin).

Each of this conflicts need to solved is a different way. Some solutions are 
listed below.

#### `tire`, `retire` and `elasticsearch-rails`

This conflict can be solved, by using explicitly the `search` method of `tire`, 
`retire` or `elasticsearch-rails`:

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

