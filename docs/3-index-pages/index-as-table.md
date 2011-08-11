<!-- Please don't edit this file. It will be clobbered. -->

# Index as a Table

By default, the index page is a table with each of the models content columns and links to
show, edit and delete the object. There are many ways to customize what gets
displayed.

## Defining Columns

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

To setup links to View, Edit and Delete a resource, use the default_actions method:

    index do
      column :title
      default_actions
    end

Alternatively, you can create a column with custom links:

    index do
      column :title
      column "Actions" do |post|
        link_to "View", admin_post_path(post)
      end
    end


## Sorting

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

## Showing and Hiding Columns

The entire index block is rendered within the context of the view, so you can
easily do things that show or hide columns based on the current context.

For example, if you were using CanCan:

    index do
      column :title, :sortable => false
      if can? :manage, Post
        column :some_secret_data
      end
    end