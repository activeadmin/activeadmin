# Sidebar Sections

To add a sidebar section to all pages for that resource:
```ruby
sidebar(:help){ 'Need help? Email us at help@example.com' }
```

You can also use Arbre syntax to define the content:
```ruby
sidebar :help do
  ul do
    li 'First Item'
    li 'Second Item'
  end
end
```

Sidebars can be rendered on a specific action by setting `only` or `except`:
```ruby
sidebar :help, only: :index do
  'Need help? Email us at help@example.com'
end
```

If you want to conditionally display a sidebar section, use the :if option and
pass it a proc which will be rendered within the context of the view.
```ruby
sidebar :help, if: ->{ current_admin_user.super_admin? }
  'Only for super admins!'
end
```

If you don't pass a block, Active Admin will attempt to render a partial.
```ruby
# Will render app/views/admin/posts/_help_sidebar.html.erb
sidebar :help
```

Or you can pass your own custom partial to render.
```ruby
sidebar :help, partial: 'custom_help_partial'
```
