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

For association columns we make an educated guess on what to display by
calling the following methods in the following order:

    :display_name, :full_name, :name, :username, :login, :title, :email, :to_s

This can be customized in config/initializers/active_admin.rb.

If the default title does not work for you, pass it as the first argument:

    index do
      column "My Custom Title", :title
    end

Sometimes that just isn't enough and you need to write some view-specific code.
For example, say we wanted a "Title" column that links to the posts admin screen.

`column` accepts a block that will be rendered for each of the objects in the collection.
The block is called once for each resource, which is passed as an argument to the block.

    index do
      column "Title" do |post|
        link_to post.title, admin_post_path(post)
      end
    end

To setup links to View, Edit and Delete a resource, use the `actions` method:

    index do
      column :title
      actions
    end

You can also append custom links to the default links:

    index do
      column :title
      actions do |post|
        link_to "Preview", admin_preview_post_path(post), :class => "member_link"
      end
    end

Or forego the default links entirely:

    index do
      column :title
      actions :defaults => false do |post|
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

## Associated Sorting

You're normally able to sort columns alphabetically, but by default you
can't sort by associated objects. Though with a few simple changes, you can.

Assuming you're on the Books index page, and Book has_one Publisher:

    controller do
      def scoped_collection
        resource_class.includes(:publisher) # prevents N+1 queries to your database
      end
    end

Then it's simple to sort by any Publisher attribute from within the index table:

    index do
      column :publisher, sortable: 'publishers.name'
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
