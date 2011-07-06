# Customizing the Index Page

Filtering and listing resources is one of the most important tasks for
administering a web application. Active Admin provides many different tools for
you to build a compelling interface into your data for the admin staff.

Built in, Active Admin has the following index renderers:

* *Table*: A table drawn with each row being a resource
* *Grid*: A set of rows and columns each cell being a resource
* *Blocks*: A set of rows (not tabular) each row being a resource
* *Blog*: A title and body content, similar to a blog index

All index pages also support scopes, filters, pagination, action items, and
sidebar sections.

## Index as a Table

By default, the index page is a table with each of the models content columns and links to
show, edit and delete the object. There are many ways to customize what gets
displayed.

### Defining Columns

To display an attribute or a method on a resource, simply pass a symbol into the
column method:

    index do
      column :title
    end

If the default title does not work for you, pass it as the first argument:

    index do
      column "My Custom Title", :title
    end

Sometimes calling methods just isn't enough and you need to write some view
specific code. For example, say we wanted a colum called Title which holds a
link to the posts admin screen.

The column method accepts a block as an argument which will then be rendered
within the context of the view for each of the objects in the collection.

    index do
      column "Title" do |post|
        link_to post.title, admin_post_path(post)
      end
    end

The block gets called once for each resource in the collection. The resource gets passed into
the block as an argument.


### Sorting

When a column is generated from an Active Record attribute, the table is
sortable by default. If you are creating a custom column, you may need to give
Active Admin a hint for how to sort the table.

If a column is defined using a block, you must pass the key to turn on sorting. The key
is the attribute which gets used to sort objects using Active Record.

    index do
      column "Title", :sortable => :title do |post|
        link_to post.title, admin_post_path(post)
      end
    end

You can turn off sorting on any column by passing false:

    index do
      column :title, :sortable => false
    end

### Showing and Hiding Columns

The entire index block is rendered within the context of the view, so you can
easily do things that show or hide columns based on the current context.

For example, if you were using CanCan:

    index do
      column :title, :sortable => false
      if can? :manage, Post
        column :some_secret_data
      end
    end

## Index as a Grid

Sometimes you want to display the index screen for a set of resources as a grid
(possibly a grid of thumbnail images). To do so, use the :grid option for the
index block.

    index :as => :grid do |product|
      link_to(image_tag(product.image_path), admin_products_path(product))
    end

The block is rendered within a cell in the grid once for each resource in the
collection. The resource is passed into the block for you to use in the view.

You can customize the number of colums that are rendered using the columns
option:

    index :as => :grid, :columns => 5 do |product|
      link_to(image_tag(product.image_path), admin_products_path(product))
    end


## Index as a Block

If you want to fully customize the display of your resources on the index
screen, Index as a Block allows you to render a block of content for each
resource.

    index :as => :block do |product|
      div :for => product do
        h2 auto_link(product.title)
        div do
          simple_format product.description
        end
      end
    end

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
