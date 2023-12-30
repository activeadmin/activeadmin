---
redirect_from: /docs/12-arbre-components.html
---

# Arbre Components

Arbre allows the creation of shareable and extendable HTML components and is
used throughout Active Admin to create view components.

## Text Node

Sometimes it makes sense to insert something into a registered resource like a
non-breaking space or some text. The text_node method can be used to insert
these elements into the page inside of other Arbre components or resource
controller functions.

```ruby
ActiveAdmin.register Post do
  show do
    panel "Post Details" do
      attributes_table_for post do
        row :id
        row 'Tags' do
          post.tags.each do |tag|
            a tag, href: admin_post_path(q: { tagged_with_cont: tag })
            text_node "&nbsp;".html_safe
          end
        end
      end
    end
  end
end
```

## Panels

A panel is a component that takes up all available horizontal space and takes a
title and a hash of attributes as arguments. If a sidebar is present, a panel
will take up the remaining space.

This will create two vertically stacked panels:

```ruby
show do
  panel "Post Details" do
    render partial: "details", locals: { post: post }
  end

  panel "Post Tags" do
    render partial: "tags", locals: { post: post }
  end
end
```

## Table For

Table For provides the ability to create tables like those present
in `index_as_table`. It takes a collection and a hash of options and then
uses `column` to build the fields to show with the table.

```ruby
table_for order.payments do
  column(:payment_type) { |payment| payment.payment_type.titleize }
  column "Received On", :created_at
  column "Details & Notes", :payment_details
  column "Amount", :amount_in_dollars
end
```

The `column` method can take a title as its first argument and data
(`:your_method`) as its second (or first if no title provided). Column also
takes a block.

### Responsive Support

For a mobile friendly `table_for`, you'll need to wrap it with a `div` and apply
horizontal overflow to enable horizontal scrolling.

```ruby
div class: "overflow-x-auto" do
  table_for payments do
    # ...
  end
end
```

### Internationalization

To customize the internationalization for the component, specify a resource to
use for translations via the `i18n` named parameter. This is only necessary for
non-`ActiveRecord::Relation` collections:

```ruby
table_for payments, i18n: Payment do
  # ...
end
```

## Status tag

Status tags provide convenient syntactic sugar for styling items that have
status. A common usage is for boolean fields or a named status like "Complete"
or "In progress". The `status_tag` will generate HTML markup and a base style
is applied. Customize with your own CSS classes and styles.

```ruby
status_tag 'In Progress'
# => <span class="status-tag" data-status="in_progress">In Progress</span>

status_tag 'Active', class: 'important', id: 'status_123', label: 'on'
# => <span class="status-tag important" id="status_123" data-status="active">on</span>
```

When providing a `true`, `false`, or `nil` value, the `status_tag` will display
"Yes", "No", or "Unknown" by default.

```ruby
status_tag true
# => <span class="status-tag" data-status="yes">Yes</span>
```

```ruby
status_tag false
# => <span class="status-tag" data-status="yes">No</span>
```

```ruby
status_tag nil
# => <span class="status-tag" data-status="unset">Unknown</span>
```

The default labels can be configured through the `"en.active_admin.status_tag"`
locale.

## Tabs

The Tabs component is helpful for saving page real estate. The first tab will be
the one open when the page initially loads and the rest hidden. You can click
each tab to toggle back and forth between them. Arbre supports unlimited number
of tabs.

```ruby
tabs do
  tab :active do
    table_for orders.active do
      # ...
    end
  end

  tab :inactive, html_options: { class: "specific_css_class" } do
    table_for orders.inactive do
      # ...
    end
  end
end
```

The `html_options` will set additional HTML attributes on the tab button.
