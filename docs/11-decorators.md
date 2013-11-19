# Decorators

Active Admin allows you to use the decorator pattern to provide view-specific
versions of a resource. [Draper](https://github.com/drapergem/draper) is
recommended but not required.

## Example usage

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  # has title, content, and image_url
end

# app/decorators/post_decorator.rb
class PostDecorator < ApplicationDecorator
  delegate_all

  def image
    h.image_tag model.image_url
  end
end

# app/admin/post.rb
ActiveAdmin.register Post do
  decorate_with PostDecorator

  index do
    column :title
    column :image
    actions
  end
end
```

## Forms

If you decorate an AA resource, the form will also be decorated.

In most cases this will work as expected, but if your decorator uses the same
method name as an attribute and it returns a modified version of the attribute's
value, you'll want to set `decorate: false` to make sure that the population of
existing values happens correctly:

```ruby
ActiveAdmin.register Post do
  decorate_with PostDecorator

  form decorate: false do |f|
    # ...
  end
end
```
