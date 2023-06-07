---
redirect_from: /docs/6-show-pages.html
---
# Customize the Show Page

The show block is rendered within the context of the view and uses
[Arbre](https://github.com/activeadmin/arbre) syntax.

With the `show` block, you can render anything you want.

```ruby
ActiveAdmin.register Post do
  show do
    h3 post.title
    div do
      simple_format post.body
    end
  end
end
```

You can render a partial at any point:

```ruby
ActiveAdmin.register Post do
  show do
    # renders app/views/admin/posts/_some_partial.html.erb
    render 'some_partial', { post: post }
  end
end
```

If you'd like to keep the default AA look, you can use `attributes_table`:

```ruby
ActiveAdmin.register Ad do
  show do
    attributes_table do
      row :title
      row :image do |ad|
        image_tag ad.image.url
      end
    end
    active_admin_comments
  end
end
```

You can also customize the title of the object in the show screen:

```ruby
show title: :name do
  # ...
end
```

If you want a more data-dense page, you can combine a sidebar:

```ruby
ActiveAdmin.register Book do
  show do
    panel "Table of Contents" do
      table_for book.chapters do
        column :number
        column :title
        column :page
      end
    end
    active_admin_comments
  end

  sidebar "Details", only: :show do
    attributes_table_for book do
      row :title
      row :author
      row :publisher
      row('Published?') { |b| status_tag b.published? }
    end
  end
end
```

If you want to keep the default show data, but add something extra to it:

```ruby
show do
  div do
    h3 'Some custom charts about this object'
    render partial: 'charts'
  end
  default_main_content
end
```
