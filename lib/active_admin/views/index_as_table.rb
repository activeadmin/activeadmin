# frozen_string_literal: true
module ActiveAdmin
  module Views

    # # Index as a Table
    #
    # By default, the index page is a table with each of the models content columns and links to
    # show, edit and delete the object. There are many ways to customize what gets
    # displayed.
    #
    # ## Defining Columns
    #
    # To display an attribute or a method on a resource, simply pass a symbol into the
    # column method:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column :title
    # end
    # ```
    #
    # For association columns we make an educated guess on what to display by
    # calling the following methods in the following order:
    #
    # ```ruby
    # :display_name, :full_name, :name, :username, :login, :title, :email, :to_s
    # ```
    #
    # This can be customized in `config/initializers/active_admin.rb`.
    #
    # If the default title does not work for you, pass it as the first argument:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column "My Custom Title", :title
    # end
    # ```
    #
    # Sometimes that just isn't enough and you need to write some view-specific code.
    # For example, say we wanted a "Title" column that links to the posts admin screen.
    #
    # `column` accepts a block that will be rendered for each of the objects in the collection.
    # The block is called once for each resource, which is passed as an argument to the block.
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column "Title" do |post|
    #     link_to post.title, admin_post_path(post)
    #   end
    # end
    # ```
    #
    # ## Defining Actions
    #
    # To setup links to View, Edit and Delete a resource, use the `actions` method:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column :title
    #   actions
    # end
    # ```
    #
    # You can also append custom links to the default links:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column :title
    #   actions do |post|
    #     item "Preview", admin_preview_post_path(post), class: "preview-link"
    #   end
    # end
    # ```
    #
    # Or forego the default links entirely:
    #
    # ```ruby
    # index do
    #   column :title
    #   actions defaults: false do |post|
    #     item "View", admin_post_path(post)
    #   end
    # end
    # ```
    #
    # Or append custom action with custom html via arbre:
    #
    # ```ruby
    # index do
    #   column :title
    #   actions do |post|
    #     a "View", href: admin_post_path(post)
    #   end
    # end
    # ```
    #
    # ## Sorting
    #
    # When a column is generated from an Active Record attribute, the table is
    # sortable by default. If you are creating a custom column, you may need to give
    # Active Admin a hint for how to sort the table.
    #
    # You can pass the key specifying the attribute which gets used to sort objects using Active Record.
    # By default, this is the column on the resource's table that the attribute corresponds to.
    # Otherwise, any attribute that the resource collection responds to can be used.
    #
    # ```ruby
    # index do
    #   column :title, sortable: :title do |post|
    #     link_to post.title, admin_post_path(post)
    #   end
    # end
    # ```
    #
    # You can turn off sorting on any column by passing false:
    #
    # ```ruby
    # index do
    #   column :title, sortable: false
    # end
    # ```
    #
    # It's also possible to sort by PostgreSQL's hstore column key. You should set `sortable`
    # option to a `column->'key'` value:
    #
    # ```ruby
    # index do
    #   column :keywords, sortable: "meta->'keywords'"
    # end
    # ```
    #
    # ## Custom sorting
    #
    # It is also possible to use database specific expressions and options for sorting by column
    #
    # ```ruby
    # order_by(:title) do |order_clause|
    #    if order_clause.order == 'desc'
    #      [order_clause.to_sql, 'NULLS LAST'].join(' ')
    #    else
    #      [order_clause.to_sql, 'NULLS FIRST'].join(' ')
    #    end
    # end
    #
    # index do
    #   column :title
    # end
    # ```
    #
    # ## Associated Sorting
    #
    # You're normally able to sort columns alphabetically, but by default you
    # can't sort by associated objects. Though with a few simple changes, you can.
    #
    # Assuming you're on the Books index page, and Book has_one Publisher:
    #
    # ```ruby
    # controller do
    #   def scoped_collection
    #     super.includes :publisher # prevents N+1 queries to your database
    #   end
    # end
    # ```
    #
    # You can also define associated objects to include outside of the
    # `scoped_collection` method:
    #
    # ```ruby
    # includes :publisher
    # ```
    #
    # Then it's simple to sort by any Publisher attribute from within the index table:
    #
    # ```ruby
    # index do
    #   column :publisher, sortable: 'publishers.name'
    # end
    # ```
    #
    # ## Showing and Hiding Columns
    #
    # The entire index block is rendered within the context of the view, so you can
    # easily do things that show or hide columns based on the current context.
    #
    # For example, if you were using CanCan:
    #
    # ```ruby
    # index do
    #   column :title, sortable: false
    #   column :secret_data if can? :manage, Post
    # end
    # ```
    #
    # ## Custom tbody HTML attributes
    #
    # In order to add HTML attributes to the tbody use the `:tbody_html` option.
    #
    # ```ruby
    # index tbody_html: { class: "my-class", data: { controller: 'stimulus-controller' } } do
    #   # columns
    # end
    # ```
    #
    # ## Custom row HTML attributes
    #
    # In order to add HTML attributes to table rows, use a proc object in the `:row_html` option.
    #
    # ```ruby
    # index row_html: ->elem { { class: ('active' if elem.active?), data: { 'element-id' => elem.id } } } do
    #   # columns
    # end
    # ```
    class IndexAsTable < ActiveAdmin::Component
      def build(page_presenter, collection)
        add_class "index-as-table"
        table_options = {
          id: "index_table_#{active_admin_config.resource_name.plural}",
          sortable: true,
          i18n: active_admin_config.resource_class,
          paginator: page_presenter[:paginator] != false,
          tbody_html: page_presenter[:tbody_html],
          row_html: page_presenter[:row_html],
          # To be deprecated, please use row_html instead.
          row_class: page_presenter[:row_class]
        }

        if page_presenter.block
          insert_tag(IndexTableFor, collection, table_options) do |t|
            instance_exec(t, &page_presenter.block)
          end
        else
          render "index_as_table_default", table_options: table_options
        end
      end

      def self.index_name
        "table"
      end

      #
      # Extend the default ActiveAdmin::Views::TableFor with some
      # methods for quickly displaying items on the index page
      #
      class IndexTableFor < ::ActiveAdmin::Views::TableFor
        # Display a column for checkbox
        def selectable_column(**options)
          return unless active_admin_config.batch_actions.any?
          column resource_selection_toggle_cell, class: options[:class], sortable: false do |resource|
            resource_selection_cell resource
          end
        end

        # Display a column for the id
        def id_column(*args)
          raise "#{resource_class.name} has no primary_key!" unless resource_class.primary_key

          options = args.extract_options!
          title = args[0].presence || resource_class.human_attribute_name(resource_class.primary_key)
          sortable = options.fetch(:sortable, resource_class.primary_key)

          column(title, sortable: sortable) do |resource|
            if controller.action_methods.include?("show")
              link_to resource.id, resource_path(resource)
            elsif controller.action_methods.include?("edit")
              link_to resource.id, edit_resource_path(resource)
            else
              resource.id
            end
          end
        end

        # Add links to perform actions.
        #
        # ```ruby
        # # Add default links.
        # actions
        #
        # # Add default links with a custom column title (empty by default).
        # actions name: 'A title!'
        #
        # # Append some actions onto the end of the default actions.
        # actions do |admin_user|
        #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
        #   item 'Grant User', grant_user_admin_user_path(admin_user)
        # end
        #
        # # Append some actions onto the end of the default actions using arbre dsl.
        # actions do |admin_user|
        #   a 'Grant Admin', href: grant_admin_admin_user_path(admin_user)
        # end
        #
        # # Custom actions without the defaults.
        # actions defaults: false do |admin_user|
        #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
        # end
        #
        # ```
        def actions(options = {}, &block)
          name = options.delete(:name) { "" }
          defaults = options.delete(:defaults) { true }

          column name, options do |resource|
            insert_tag(TableActions, class: "data-table-resource-actions") do
              render "index_table_actions_default", defaults_data(resource) if defaults
              if block
                block_result = instance_exec(resource, &block)
                text_node block_result unless block_result.is_a? Arbre::Element
              end
            end
          end
        end

        private

        def defaults_data(resource)
          localizer = ActiveAdmin::Localizers.resource(active_admin_config)
          {
            resource: resource,
            view_label: localizer.t(:view),
            edit_label: localizer.t(:edit),
            delete_label: localizer.t(:delete),
            delete_confirmation_text: localizer.t(:delete_confirmation)
          }
        end

        class TableActions < ActiveAdmin::Component
          def item *args, **kwargs
            text_node link_to(*args, **kwargs)
          end
        end
      end # IndexTableFor
    end
  end
end
