---
redirect_from: /docs/11-decorators.html
---

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
class PostDecorator < Draper::Decorator
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

You can pass any decorator class as an argument to `decorate_with`
as long as it accepts the record to be decorated as a parameter in
the initializer, and responds to all the necessary methods.

```ruby
# app/decorators/post_decorator.rb
class PostDecorator
  attr_reader :post
  delegate_missing_to :post

  def initialize(post)
    @post = post
  end
end
```

## Forms

By default, ActiveAdmin does *not* decorate the resource used to render forms.
If you need ActiveAdmin to decorate the forms, you can pass `decorate: true` to the
form block.

```ruby
ActiveAdmin.register Post do
  decorate_with PostDecorator

  form decorate: true do |f|
    # ...
  end
end
```
