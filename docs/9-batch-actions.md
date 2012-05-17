# Index Batch Actions

By default, the index view includes a way to quickly delete records from the listing,
as well as an API for you to easily create your own "Batch Action" for handling a request to operate
on multiple records at once.

## Provided Batch Action

The `batch_action` API provides one default batch action for use in your application immediately, for deleting
multiple records at once.  You are able to disable this action if you desire (see below).

## Creating Your Own Batch Actions

To create your own batch action, use the `batch_action` method.  You are provided an array of record IDs
to operate on.  The array should contain at least one ID.

    ActiveAdmin.register Post do
      batch_action :flag do |selection|
        Post.find(selection).each do |post|
          post.flag! :hot
        end
      end
    end

### Disabling Batch Actions

You can disable batch actions at the application or namespace level in
`config/initializers/active_admin.rb`:

    ActiveAdmin.setup do |config|

      # Disable all batch actions
      config.batch_actions = false


      # Or disable for a given namespace
      config.namespace :admin do |admin|
        admin.batch_actions = false
      end
    end

You can disable batch actions on any given resource using:

    ActiveAdmin.register Post do
      config.batch_actions = false
    end


### Modifying a Previously Registered Batch Action

If you wanted to modify the behavior of the provided "Delete" batch action, you can override by:

    ActiveAdmin.register Post do
      batch_action :destroy, :if => proc { can?( :destroy, Post ) } do |selection|
        redirect_to collection_path, :alert => "Didn't really delete these!"
      end
    end

### Removing a Batch Action

You can also remove batch actions by simply passing false as the second parameter:

    ActiveAdmin.register Post do
      batch_action :destroy, false
    end

### Conditional Display of Batch Action

You can control whether or not the batch action is available via the `:if` option. Provide a boolean or a proc, which is executed in context of the view.

    ActiveAdmin.register Post do
      batch_action :flag, :if => proc { false } do |selection|
        # This action won't ever be displayed
      end
    end

### Batch Action Priority in Menu

You can also change the order of batch actions, by providing a value for the :priority param:

    ActiveAdmin.register Post do
      batch_action :destroy, :priority => 1 do |selection|
        # Do some deleting in here...
      end
    end

### Batch Action I18n of Labels

By default, the name of the batch action will be used to lookup a label for the
menu. It will lookup in `active_admin.batch_actions.labels.#{your_batch_action_name}`. For
example:

    ActiveAdmin.register Post do
      batch_action :publish do |selection|
        # do some publishing...
      end
    end

Can be translated with:

    # config/locales/en.yml
    en:
      active_admin:
        batch_actions:
          labels:
            publish: "Publish"

### Batch Action Confirmation   

You can also request that the user confirm the action, before the action is performed:

    ActiveAdmin.register Post do
      batch_action :destroy, :confirm => "Are you sure you want to delete all of these?" do |selection|
        # Do some deleting...
      end
    end

### Customizing Table Columns

To include the column with checkboxes in after overriding the list of columns for the `index` block in the *Table* listing, use the following helper as seen below:

    ActiveAdmin.register Post do

      batch_action :flag do |selection|
        Post.find(selection).each { |p| p.flag! }
        redirect_to collection_path, :notice => "Posts flagged!"
      end

      index do
        selectable_column
        column :title
        default_actions
      end

    end


### Support for Other Index Types

You can easily use `batch_action` in the other index views, *Grid*, *Block*, and *Blog*; however, these views will require more custom styling to fit your application needs.

    ActiveAdmin.register Post do

      # By default, the "Delete" batch action is provided

      # Index as Grid
      index as: :grid do |post|
        resource_selection_cell post
        h2 auto_link( post )
      end

      # Index as Blog requires nothing special

      # Index as Block
      index as: :block do |post|
        div for: post do
          resource_selection_cell post
        end
      end

    end
