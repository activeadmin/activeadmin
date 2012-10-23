module ActiveAdmin
  module Views

    # = Index as a Table
    #
    # By default, the index page is a table with each of the models content columns and links to
    # show, edit and delete the object. There are many ways to customize what gets
    # displayed.
    #
    # == Defining Columns
    #
    # To display an attribute or a method on a resource, simply pass a symbol into the
    # column method:
    #
    #     index do
    #       selectable_column
    #       column :title
    #     end
    #
    # If the default title does not work for you, pass it as the first argument:
    #
    #     index do
    #       selectable_column
    #       column "My Custom Title", :title
    #     end
    #
    # Sometimes calling methods just isn't enough and you need to write some view
    # specific code. For example, say we wanted a colum called Title which holds a
    # link to the posts admin screen.
    #
    # The column method accepts a block as an argument which will then be rendered
    # within the context of the view for each of the objects in the collection.
    #
    #     index do
    #       selectable_column
    #       column "Title" do |post|
    #         link_to post.title, admin_post_path(post)
    #       end
    #     end
    #
    # The block gets called once for each resource in the collection. The resource gets passed into
    # the block as an argument.
    #
    # To setup links to View, Edit and Delete a resource, use the default_actions method:
    #
    #     index do
    #       selectable_column
    #       column :title
    #       default_actions
    #     end
    #
    # Alternatively, you can create a column with custom links:
    #
    #     index do
    #       selectable_column
    #       column :title
    #       column "Actions" do |post|
    #         link_to "View", admin_post_path(post)
    #       end
    #     end
    #
    #
    # == Sorting
    #
    # When a column is generated from an Active Record attribute, the table is
    # sortable by default. If you are creating a custom column, you may need to give
    # Active Admin a hint for how to sort the table.
    #
    # If a column is defined using a block, you must pass the key to turn on sorting. The key
    # is the attribute which gets used to sort objects using Active Record.
    #
    # By default, this is the column on the resource's table that the attribute corresponds to. 
    # Otherwise, any attribute that the resource collection responds to can be used.
    #
    #     index do
    #       column "Title", :sortable => :title do |post|
    #         link_to post.title, admin_post_path(post)
    #       end
    #     end
    #
    # You can also sort using an attribute on another table by passing the table name
    # and the attribute separated by a dot:
    #
    #     index do
    #       column :title, :sortable => 'categories.name'
    #     end
    #
    # You can turn off sorting on any column by passing false:
    #
    #     index do
    #       column :title, :sortable => false
    #     end
    #
    # == Showing and Hiding Columns
    #
    # The entire index block is rendered within the context of the view, so you can
    # easily do things that show or hide columns based on the current context.
    #
    # For example, if you were using CanCan:
    #
    #     index do
    #       column :title, :sortable => false
    #       if can? :manage, Post
    #         column :some_secret_data
    #       end
    #     end
    #
    class IndexAsTable < ActiveAdmin::Component

      def build(page_presenter, collection)
        table_options = {
          :id => "index_table_#{active_admin_config.resource_name.plural}",
          :sortable => true,
          :class => "index_table index",
          :i18n => active_admin_config.resource_class,
          :paginator => page_presenter[:paginator] != false
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
          id_column
          resource_class.content_columns.each do |col|
            column col.name.to_sym
          end
          default_actions
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
          column( resource_selection_toggle_cell, { :class => "selectable" } ) { |resource| resource_selection_cell( resource ) }
        end

        # Display a column for the id
        def id_column
          column(resource_class.human_attribute_name(resource_class.primary_key), :sortable => resource_class.primary_key) do |resource| 
            link_to resource.id, resource_path(resource), :class => "resource_id_link"
          end
        end

        # Add links to perform actions.
        #
        #   # Add default links.
        #   actions
        #
        #   # Append some actions onto the end of the default actions.
        #   actions do |admin_user|
        #     link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
        #   end
        #
        #   # Custom actions without the defaults.
        #   actions :defaults => false do |admin_user|
        #     link_to 'Grant Admin', grant_admin_admin_user_path(admin_user)
        #   end
        def actions(options = {}, &block)
          options = {
            :name => "",
            :defaults => true
          }.merge(options)
          column options[:name] do |resource|
            text_node default_actions(resource) if options[:defaults]
            text_node instance_exec(resource, &block) if block_given?
          end
        end

        def default_actions(*args)
          links = proc do |resource|
            links = ''.html_safe
            if controller.action_methods.include?('show') && authorized?(ActiveAdmin::Auth::READ, resource)
              links << link_to(I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link")
            end
            if controller.action_methods.include?('edit') && authorized?(ActiveAdmin::Auth::UPDATE, resource)
              links << link_to(I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link")
            end
            if controller.action_methods.include?('destroy') && authorized?(ActiveAdmin::Auth::DESTROY, resource)
              links << link_to(I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :data => {:confirm => I18n.t('active_admin.delete_confirmation')}, :class => "member_link delete_link")
            end
            links
          end

          options = args.extract_options!
          if options.present? || args.empty?
            actions options
          else
            links.call(args.first)
          end
        end

        # Display A Status Tag Column
        #
        #   index do |i|
        #     i.status_tag :state
        #   end
        #
        #   index do |i|
        #     i.status_tag "State", :status_name
        #   end
        #
        #   index do |i|
        #     i.status_tag do |post|
        #       post.published? ? 'published' : 'draft'
        #     end
        #   end
        #
        def status_tag(*args, &block)
          col = Column.new(*args, &block)
          data = col.data
          col.data = proc do |resource|
            status_tag call_method_or_proc_on(resource, data)
          end
          add_column col
        end
      end # TableBuilder

    end # Table
  end
end
