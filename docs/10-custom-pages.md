---
redirect_from: /docs/10-custom-pages.html
---

# Custom Pages

If you have data you want on a standalone page that isn't tied to a resource,
custom pages provide you with a familiar syntax and feature set:

* a menu item
* sidebars
* action items
* page actions

## Create a new Page

Creating a page is as simple as calling `register_page`:

```ruby
# app/admin/calendar.rb
ActiveAdmin.register_page "Calendar" do
  content do
    para "Hello World"
  end
end
```

Anything rendered within `content` will be the main content on the page.
Partials behave exactly the same way as they do for resources:

```ruby
# app/admin/calendar.rb
ActiveAdmin.register_page "Calendar" do
  content do
    render partial: 'calendar'
  end
end

# app/views/admin/calendar/_calendar.html.arb
table do
  thead do
    tr do
      %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].each &method(:th)
    end
  end
  tbody do
    # ...
  end
end
```

## Customize the Menu

See the [Menu](2-resource-customization.md#customize-the-menu) documentation.

## Customize the breadcrumbs

```ruby
ActiveAdmin.register_page "Calendar" do
  breadcrumb do
    ['admin', 'calendar']
  end
end
```

## Customize the Namespace

We use the `admin` namespace by default, but you can use anything:

```ruby
# Available at /today/calendar
ActiveAdmin.register_page "Calendar", namespace: :today

# Available at /calendar
ActiveAdmin.register_page "Calendar", namespace: false
```

## Belongs To

To nest the page within another resource, you can use the `belongs_to` method:

```ruby
ActiveAdmin.register Project
ActiveAdmin.register_page "Status" do
  belongs_to :project
end
```

See also the [Belongs To](2-resource-customization.md#belongs-to) documentation
and examples.

## Add a Sidebar

See the [Sidebars](7-sidebars.md) documentation.

## Add an Action Item

Just like other resources, you can add action items. The difference here being that
`:only` and `:except` don't apply because there's only one page it could apply to.

```ruby
action_item :view_site do
  link_to "View Site", "/"
end
```

## Add a Page Action

Page actions are custom controller actions (which mirror the resource DSL for
the same feature).

```ruby
page_action :add_event, method: :post do
  # ...
  redirect_to admin_calendar_path, notice: "Your event was added"
end

action_item :add do
  link_to "Add Event", admin_calendar_add_event_path, method: :post
end
```

This defines the route `/admin/calendar/add_event` which can handle HTTP POST requests.

Clicking on the action item will reload page and display the message "Your event
was added"

Page actions can handle multiple HTTP verbs.

```ruby
page_action :add_event, method: [:get, :post] do
  # ...
end
```

See also the [Custom Actions](8-custom-actions.md#http-verbs) example.
