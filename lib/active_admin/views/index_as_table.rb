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
    #     item "Preview", admin_preview_post_path(post), class: "member_link"
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
    # In case you prefer to list actions links in a dropdown menu:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   column :title
    #   actions dropdown: true do |post|
    #     item "Preview", admin_preview_post_path(post)
    #   end
    # end
    # ```
    #
    # In addition, you can insert the position of the row in the greater
    # collection by using the index_column special command:
    #
    # ```ruby
    # index do
    #   selectable_column
    #   index_column
    #   column :title
    # end
    # ```
    #
    # index_column take an optional offset parameter to allow a developer to set
    # the starting number for the index (default is 1).
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
    # ## Custom row class
    #
    # In order to add special class to table rows pass the proc object as a `:row_class` option
    # of the `index` method.
    #
    # ```ruby
    # index row_class: ->elem { 'active' if elem.active? } do
    #   # columns
    # end
    # ```
    #
    class IndexAsTable < ActiveAdmin::Component

      def build(page_presenter, collection)
        table_options = {
          id: "index_table_#{active_admin_config.resource_name.plural}",
          sortable: true,
          class: "index_table index",
          i18n: active_admin_config.resource_class,
          paginator: page_presenter[:paginator] != false,
          row_class: page_presenter[:row_class],
          has_footer: page_presenter[:has_footer]
        }

        table_for collection, table_options do |t|
          table_config_block = page_presenter.block || default_table
          instance_exec(t, &table_config_block)
        end
      end

      def table_for(*args, &block)
        insert_tag IndexTableFor, *args, &block
      end

      def default_table
        proc do
          selectable_column
          id_column if resource_class.primary_key
          active_admin_config.resource_columns.each do |attribute|
            column attribute
          end
          actions
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
        def selectable_column
          return unless active_admin_config.batch_actions.any?
          column resource_selection_toggle_cell, class: "col-selectable", sortable: false do |resource|
            resource_selection_cell resource
          end
        end

        def index_column(start_value = 1)
          column "#", class: "col-index", sortable: false do |resource|
            @collection.offset_value + @collection.index(resource) + start_value
          end
        end

        # Display a column for the id
        def id_column
          raise "#{resource_class.name} has no primary_key!" unless resource_class.primary_key
          column(resource_class.human_attribute_name(resource_class.primary_key), sortable: resource_class.primary_key) do |resource|
            if controller.action_methods.include?("show")
              link_to resource.id, resource_path(resource), class: "resource_id_link"
            elsif controller.action_methods.include?("edit")
              link_to resource.id, edit_resource_path(resource), class: "resource_id_link"
            else
              resource.id
            end
          end
        end

        def default_actions
          raise "`default_actions` is no longer provided in ActiveAdmin 1.x. Use `actions` instead."
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
        # # Append some actions onto the end of the default actions displayed in a Dropdown Menu
        # actions dropdown: true do |admin_user|
        #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
        # end
        #
        # # Custom actions without the defaults displayed in a Dropdown Menu.
        # actions defaults: false, dropdown: true, dropdown_name: 'Additional actions' do |admin_user|
        #   item 'Grant Admin', grant_admin_admin_user_path(admin_user)
        # end
        #
        # ```
        def actions(options = {}, &block)
          name = options.delete(:name) { "" }
          defaults = options.delete(:defaults) { true }
          dropdown = options.delete(:dropdown) { false }
          dropdown_name = options.delete(:dropdown_name) { I18n.t "active_admin.dropdown_actions.button_label", default: "Actions" }

          options[:class] ||= "col-actions"

          column name, options do |resource|
            if dropdown
              dropdown_menu dropdown_name do
                defaults(resource) if defaults
                instance_exec(resource, &block) if block_given?
              end
            else
              table_actions do
                defaults(resource, css_class: :member_link) if defaults
                if block_given?
                  block_result = instance_exec(resource, &block)
                  text_node block_result unless block_result.is_a? Arbre::Element
                end
              end
            end
          end
        end

        private

        def defaults(resource, options = {})
          localizer = ActiveAdmin::Localizers.resource(active_admin_config)
          if controller.action_methods.include?("show") && authorized?(ActiveAdmin::Auth::READ, resource)
            item localizer.t(:view), resource_path(resource), class: "view_link #{options[:css_class]}", title: localizer.t(:view)
          end
          if controller.action_methods.include?("edit") && authorized?(ActiveAdmin::Auth::UPDATE, resource)
            item localizer.t(:edit), edit_resource_path(resource), class: "edit_link #{options[:css_class]}", title: localizer.t(:edit)
          end
          if controller.action_methods.include?("destroy") && authorized?(ActiveAdmin::Auth::DESTROY, resource)
            item localizer.t(:delete), resource_path(resource), class: "delete_link #{options[:css_class]}", title: localizer.t(:delete),
                                                                method: :delete, data: { confirm: localizer.t(:delete_confirmation) }
          end
        end

        class TableActions < ActiveAdmin::Component
          builder_method :table_actions

          def item *args, **kwargs
            text_node link_to(*args, **kwargs)
          end
        end
      end # IndexTableFor

    end
  end
end
