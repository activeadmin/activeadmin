# Customize the Show Page

Customize the show page is as simple as implementing the show block:
```ruby
ActiveAdmin.register Post do
  show do
    h3 post.title
    div do
      simple_format post.body
    end
    active_admin_comments
  end
end
```

The show block is rendered within the context of the view and uses the Arbre HTML DSL. You
can also render a partial at any point.
```ruby
ActiveAdmin.register Post do
  show do
    # renders app/views/admin/posts/_some_partial.html.erb
    render 'some_partial'
  end
end
```

If you'd like to keep the default active_admin look, you can use `attributes_table`:
```ruby
ActiveAdmin.register Ad do
  show do |ad|
    attributes_table do
      row :title
      row(:image){ image_tag ad.image.url }
    end
    active_admin_comments
  end
end
```

You can customize the title of the object in the show screen.
The default is the resource name and the ID.
```ruby
show title: :name do
  # ...
end
```

