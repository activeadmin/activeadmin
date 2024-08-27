---
redirect_from: /docs/3-index-pages.html
---

# Customizing the Index Page

Filtering and listing resources is one of the most important tasks for
administering a web application. Active Admin provides many different tools for
you to build a compelling interface into your data for the admin staff.

Built in, Active Admin has the following index renderers:

* *Table*: A table drawn with each row being a resource ([View Table Docs](3-index-pages/index-as-table.md))
* *Grid*: A set of rows and columns each cell being a resource ([View Grid Docs](3-index-pages/index-as-grid.md))
* *Blocks*: A set of rows (not tabular) each row being a resource ([View Blocks Docs](3-index-pages/index-as-block.md))
* *Blog*: A title and body content, similar to a blog index ([View Blog Docs](3-index-pages/index-as-blog.md))

All index pages also support scopes, filters, pagination, action items, and
sidebar sections.

## Multiple Index Pages

Sometime you may want more than one index page for a resource to represent
different views to the user. If multiple index pages exist, Active Admin will
automatically build links at the top of the default index page. Including
multiple views is simple and requires creating multiple index components in
your resource.

```ruby
index do
  id_column
  column :image_title
  actions
end

index as: :grid do |product|
  link_to image_tag(product.image_path), admin_product_path(product)
end
```

The first index component will be the default index page unless you indicate
otherwise by setting `:default` to true.

```ruby
index do
  column :image_title
  actions
end

index as: :grid, default: true do |product|
  link_to image_tag(product.image_path), admin_product_path(product)
end
```

## Custom Index

Active Admin does not limit the index page to be a table, block, blog or grid.
If you've created your own [custom index](3-index-pages/custom-index.md) page it
can be included by setting `:as` to the class of the index component you created.

```ruby
index as: ActiveAdmin::Views::IndexAsMyIdea do
  column :image_title
  actions
end
```

## Index Filters

By default the index screen includes a "Filters" sidebar on the right hand side
with a filter for each attribute of the registered model. You can customize the
filters that are displayed as well as the type of widgets they use.

To display a filter for an attribute, use the `filter` method

```ruby
ActiveAdmin.register Post do
  filter :title
end
```

Out of the box, Active Admin supports the following filter types:

* *:string* -  A drop down for selecting "Contains", "Equals", "Starts with",
  "Ends with" and an input for a value.
* *:date_range* - A start and end date field with calendar inputs
* *:numeric* - A drop down for selecting "Equal To", "Greater Than" or "Less
  Than" and an input for a value.
* *:select* - A drop down which filters based on a selected item in a collection
  or all.
* *:check_boxes* - A list of check boxes users can turn on and off to filter

By default, Active Admin will pick the most relevant filter based on the
attribute type. You can force the type by passing the `:as` option.

```ruby
filter :author, as: :check_boxes
```

The `:check_boxes` and `:select` types accept options for the collection. By default
it attempts to create a collection based on an association. But you can pass in
the collection as a proc to be called at render time.

```ruby
filter :author, as: :check_boxes, collection: proc { Author.all }
```

To override options for string or numeric filter pass `filters` option.

```ruby
  filter :title, filters: [:start, :end]
```

Also, if you don't need the select with the options 'cont', 'eq', 'start' or
'end' just add the option to the filter name with an underscore.

For example:

```ruby
filter :name_eq
# or
filter :name_cont
```

You can change the filter label by passing a label option:

```ruby
filter :author, label: 'Something else'
```

By default, Active Admin will try to use ActiveModel I18n to determine the label.

You can also filter on more than one attribute of a model using the [Ransack
search predicate
syntax](https://github.com/activerecord-hackery/ransack/wiki/Basic-Searching).
If using a custom search method, you will also need to specify the field type
using `:as` and the label.

```ruby
filter :first_name_or_last_name_cont, as: :string, label: "Name"
```

Filters can also be disabled for a resource, a namespace or the entire
application.

To disable for a specific resource:

```ruby
ActiveAdmin.register Post do
  config.filters = false
end
```

To disable for a namespace, in the initializer:

```ruby
ActiveAdmin.setup do |config|
  config.namespace :my_namespace do |my_namespace|
    my_namespace.filters = false
  end
end
```

Or to disable for the entire application:

```ruby
ActiveAdmin.setup do |config|
  config.filters = false
end
```

You can also add a filter and still preserve the default filters:

```ruby
preserve_default_filters!
filter :author
```

Or you can also remove a filter and still preserve the default filters:

```ruby
preserve_default_filters!
remove_filter :id
```

### Allow Filtering Attributes

By default, filtering on any model attributes is denied, this is a security
feature to prevent users from filtering (reading by guessing) attributes that
shouldn't be accessible by them.
To allow filtering on attributes, follow the [Ransack Authorization guide]
to extend `ransackable_attributes` class method.

## Index Scopes

You can define custom scopes for your index page. This will add a tab bar above
the index table to quickly filter your collection on pre-defined scopes. There
are a number of ways to define your scopes:

```ruby
scope :all, default: true

# assumes the model has a scope called ':active'
scope :active

# renames model scope ':leaves' to ':subcategories'
scope "Subcategories", :leaves

# Dynamic scope name
scope ->{ Date.today.strftime '%A' }, :published_today

# custom scope not defined on the model
scope("Inactive") { |scope| scope.where(active: false) }

# conditionally show a custom controller scope
scope "Published", if: -> { current_admin_user.can? :manage, Posts } do |posts|
  posts.published
end
```

Scopes can be labelled with a translation, e.g.
`active_admin.scopes.scope_method`.

### Scopes groups

You can assign group names to scopes to keep related scopes together and separate them from the rest.

```ruby
# a scope in the default group
scope :all

# two scopes used to filter by status
scope :active, group: :status
scope :inactive, group: :status

# two scopes used to filter by date
scope :today, group: :date
scope :tomorrow, group: :date
```

## Index default sort order

You can define the default sort order for index pages:

```ruby
ActiveAdmin.register Post do
  config.sort_order = 'name_asc'
end
```

## Index pagination

You can set the number of records per page as default:

```ruby
ActiveAdmin.setup do |config|
  config.default_per_page = 30
end
```

You can set the number of records per page per resources:

```ruby
ActiveAdmin.register Post do
  config.per_page = 10
end
```

Or allow users to choose themselves using dropdown with values

```ruby
ActiveAdmin.register Post do
  config.per_page = [10, 50, 100]
end
```

You can change it per request / action too:

```ruby
controller do
  before_action only: :index do
    @per_page = 100
  end
end
```

You can also disable pagination:

```ruby
ActiveAdmin.register Post do
  config.paginate = false
end
```

If you have a very large database, you might want to disable `SELECT COUNT(*)`
queries caused by the pagination info at the bottom of the page:

```ruby
ActiveAdmin.register Post do
  index pagination_total: false do
    # ...
  end
end
```

## Customizing Download Links

You can easily remove or customize the download links you want displayed:

```ruby
# Per resource:
ActiveAdmin.register Post do

  index download_links: false
  index download_links: [:pdf]
  index download_links: proc{ current_user.can_view_download_links? }

end

# For the entire application:
ActiveAdmin.setup do |config|

  config.download_links = false
  config.download_links = [:csv, :xml, :json, :pdf]
  config.download_links = proc { current_user.can_view_download_links? }

end
```

Note: you have to actually implement PDF rendering for your action, ActiveAdmin
does not provide this feature. This setting just allows you to specify formats
that you want to show up under the index collection.

You'll need to use a PDF rendering library like PDFKit or WickedPDF to get the
PDF generation you want.

[Ransack Authorization guide]: https://activerecord-hackery.github.io/ransack/going-further/other-notes/#authorization-allowlistingdenylisting
