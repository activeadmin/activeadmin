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

## Index Filters

By default the index screen includes a "Filters" sidebar on the right hand side
with a filter for each attribute of the registered model. You can customize the
filters that are displayed as well as the type of widgets they use.

To display a filter for an attribute, use the filter method

    ActiveAdmin.register Post do
      filter :title
    end

Out of the box, Active Admin supports the following filter types:

* *:string* - A search field
* *:date_range* - A start and end date field with calendar inputs
* *:numeric* - A drop down for selecting "Equal To", "Greater Than" or "Less
  Than" and an input for a value.
* *:select* - A drop down which filters based on a selected item in a collection
  or all.
* *:check_boxes* - A list of check boxes users can turn on and off to filter

By default, Active Admin will pick the most relevant filter based on the
attribute type. You can force the type by passing the :as option.

    filter :author, :as => :check_boxes

The :check_boxes and :select types accept options for the collection. By default
it attempts to create a collection based on an association. But you can pass in
the collection as a proc to be called at render time.

    # Will call available
    filter :author, :as => :check_boxes, :collection => proc { Author.all }

You can change the filter label by passing a label option:

    filter :author, :label => 'Author'

By default, Active Admin will try to use ActiveModel I18n to determine the label.

## Index default sort order

You can define the default sort order for index pages:

    ActiveAdmin.register Post do
      config.sort_order = "name_asc"
    end

## Index pagination


You can set the number of records per page per resources:

    ActiveAdmin.register Post do
      config.per_page = 10
    end

You can also disable pagination:

    ActiveAdmin.register Post do
      config.paginate = false
    end
