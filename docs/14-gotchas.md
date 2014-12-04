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

There are two knowing gotchas with helpers. This hopfully will help you to
find a solution.

### Helpers are not reloading in development

This is a known and still open [issue](https://github.com/activeadmin/activeadmin/issues/697)
the only way is to restart your server each time you change a helper.

### Helper maybe not included by default

If you use `config.action_controller.include_all_helpers = false` in your application config, 
you need to include it by hand.

#### Solutions

##### First use a monky patch

This works for all ActiveAdmin rources at once.

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
