---
redirect_from: /docs/3-index-pages/index-as-blog.html
---

# Index as Blog

Render your index page as a set of posts. The post has two main options:
title and body.

```ruby
index as: :blog do
  title :my_title # Calls #my_title on each resource
  body  :my_body  # Calls #my_body on each resource
end
```

## Post Title

The title is the content that will be rendered within a link to the
resource. There are two main ways to set the content for the title

First, you can pass in a method to be called on your resource. For example:

```ruby
index as: :blog do
  title :a_method_to_call
end
```

Second, you can pass a block to the tile option which will then be
used as the contents of the title. The resource being rendered
is passed in to the block. For Example:

```ruby
index as: :blog do
  title do |post|
    span post.title,      class: 'title'
    span post.created_at, class: 'created_at'
  end
end
```

## Post Body

The body is rendered underneath the title of each post. The same two
style of options work as the Post Title above.

Call a method on the resource as the body:

```ruby
index as: :blog do
  title :my_title
  body :my_body
end
```

Or, render a block as the body:

```ruby
index as: :blog do
  title :my_title
  body do |post|
    div truncate post.title
    div class: 'meta' do
      span "Post in #{post.categories.join(', ')}"
    end
  end
end
```
