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
            a tag, href: admin_post_path(q: {tagged_with_contains: tag})
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

This will create two stacked panels:

```ruby
show do
  panel "Post Details" do
    render partial: "details", locals: {post: post}
  end

  panel "Post Tags" do
    render partial: "tags",    locals: {post: post}
  end
end
```

## Columns

The Columns component allows you draw content into scalable columns. All you
need to do is define the number of columns and the component will take care of
the rest.

### Simple Columns

To create simple columns, use the `columns` method. Within the block, call
the #column method to create a new column.

```ruby
columns do
  column do
    span "Column #1"
  end

  column do
    span "Column #2"
  end
end
```

### Spanning Multiple Columns

To create columns that have multiple spans, pass the :span option to the column
method.

```ruby
columns do
  column span: 2 do
    span "Column # 1"
  end
  column do
    span "Column # 2"
  end
end
```

By default, each column spans 1 column. The above layout would have 2 columns,
the first being twice as large as the second.

### Custom Column Widths

Active Admin uses a fluid width layout, causing column width to be defined
using percentages. Due to using this style of layout, columns can shrink or
expand past points that may not be desirable. To overcome this issue,
columns provide `:max_width` and `:min_width` options.

```ruby
columns do
  column max_width: "200px", min_width: "100px" do
    span "Column # 1"
  end
  column do
    span "Column # 2"
  end
end
```

In the above example, the first column will not grow larger than 200px and will
not shrink less than 100px.

## Table For

Table For provides the ability to create tables like those present
in `index_as_table`. It takes a collection and a hash of options and then
uses `column` to build the fields to show with the table.

```ruby
table_for order.payments do
  column(:payment_type) { |payment| payment.payment_type.titleize }
  column "Received On",     :created_at
  column "Details & Notes", :payment_details
  column "Amount",          :amount_in_dollars
end
```

the `column` method can take a title as its first argument and data
(`:your_method`) as its second (or first if no title provided). Column also
takes a block.

## Status tag

Status tags provide convenient syntactic sugar for styling items that have
status. A common example of where the status tag could be useful is for orders
that are complete or in progress. `status_tag` takes a status, like
"In Progress", and a hash of options. The status_tag will generate HTML markup
that Active Admin CSS uses in styling.

```ruby
status_tag 'In Progress'
# => <span class='status_tag in_progress'>In Progress</span>

status_tag 'active', class: 'important', id: 'status_123', label: 'on'
# => <span class='status_tag active important' id='status_123'>on</span>
```

## Tabs

The Tabs component is helpful for saving page real estate. The first tab will be
the one open when the page initially loads and the rest hidden. You can click
each tab to toggle back and forth between them. Arbre supports unlimited number
of tabs.

```ruby
tabs do
  tab :active do
    table_for orders.active do
      ...
    end
  end

  tab :inactive do
    table_for orders.inactive do
      ...
    end
  end
end
```
