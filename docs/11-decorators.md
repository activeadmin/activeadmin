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
