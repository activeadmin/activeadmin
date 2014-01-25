# Sidebar Sections

Sidebars allow you to put whatever content you want on the side the page.

```ruby
sidebar :help do
  "Need help? Email us at help@example.com"
end
```

This will generate a sidebar on every page for that resource. The first
argument is used as the title, and can be a symbol, string, or lambda.

You can also use [Arbre](https://github.com/gregbell/arbre) to define HTML content.

```ruby
sidebar :help do
  ul do
    li "Second List First Item"
    li "Second List Second Item"
  end
end
```

Sidebars can be rendered on a specific action by passing `:only` or `:except`.

```ruby
sidebar :help, only: :index do
  "Need help? Email us at help@example.com"
end
```

If you want to conditionally display a sidebar section, use the :if option and
pass it a proc which will be rendered within the view context.

```ruby
sidebar :help, if: proc{ current_admin_user.super_admin? } do
  "Only for super admins!"
end
```

You can also render a partial:

```ruby
sidebar :help                    # app/views/admin/posts/_help_sidebar.html.erb
sidebar :help, partial: 'custom' # app/views/admin/posts/_custom.html.erb
```

It's possible to add custom class name to the sidebar parent element by passing
`class` option:

```ruby
sidebar :help, class: 'custom_class'
```

By default sidebars are positioned in the same order as they defined, but it's also
possible to specify their position manually:

```ruby
sidebar :help, priority: 0 # will push Help section to the top (above default Filters section)
```

Default sidebar priority is `10`.
