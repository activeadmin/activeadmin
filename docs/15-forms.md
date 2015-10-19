# Form Objects

Active Admin allows you to use the form objects to provide ActiveAdmin-specific
validations of a resource. [Reform](https://github.com/apotonick/reform)

## Example usage

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  # has title, content, and image_url
end

# app/forms/post_form.rb
class PostForm < Reform::Form
  property :title, validates: { presence: true, length: { minimum: 10 } }
  property :content, validates: { presence: true }
  property :image_url, validates: { presence: true }
end

# app/admin/post.rb
ActiveAdmin.register Post do
  form_class PostForm

  index do
    column :title
    column :image
    actions
  end
end
```
