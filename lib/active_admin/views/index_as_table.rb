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
    #       column :title
    #     end
    #
    # For association columns we make an educated guess on what to display by
    # calling the following methods in the following order:
    #
    #     :display_name, :full_name, :name, :username, :login, :title, :email, :to_s
    #
    # This can be customized in config/initializers/active_admin.rb.
    #
    # If the default title does not work for you, pass it as the first argument:
    #
    #     index do
    #       column "My Custom Title", :title
    #     end
    #
    # Sometimes that just isn't enough and you need to write some view-specific code.
    # For example, say we wanted a "Title" column that links to the posts admin screen.
    #
    # `column` accepts a block that will be rendered for each of the objects in the collection.
    # The block is called once for each resource, which is passed as an argument to the block.
    #
    #     index do
    #       column "Title" do |post|
    #         link_to post.title, admin_post_path(post)
    #       end
    #     end
    #
    # To setup links to View, Edit and Delete a resource, use the `actions` method:
    #
    #     index do
    #       column :title
    #       actions
    #     end
    #
    # You can also append custom links to the default links:
    #
    #     index do
    #       column :title
    #       actions do |post|
    #         link_to "Preview", admin_preview_post_path(post), :class => "member_link"
    #       end
    #     end
    #
    # Or forego the default links entirely:
    #
    #     index do
    #       column :title
    #       actions :defaults => false do |post|
    #         link_to "View", admin_post_path(post)
    #       end
    #     end
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
    # You can also sort using an attribute on another table by passing the
    # association name and the attribute separated by an underscore:
    #
    #     index do
    #       column :title, :sortable => 'category_name'
    #     end
    #
    # And you can also sort on multiple columns, either of this resource or
    # of associated ones, joining conditions using _and_:
    #
    #     index do
    #       column :title, :sortable => 'author_first_name_and_category_name_and_title'
    #     end
    #
    # For complex sorting schemes, this definition may become cumbersome: in
    # these cases, define two scopes in your model, and refer to them in the
    # :sortable option:
    #
    #     class Post
    #       scope :sort_by_custom_name_asc,  proc { joins(...).order(...)... }
    #       scope :sort_by_custom_name_desc, proc { joins(...).order(...)... }
    #     end
    #
    #     index to
    #       column :title, :sortable => 'custom_name'
    #     end
    #
    # This leverages the [meta_sort feature](https://github.com/ernie/meta_search/#sorting-columns)
    # in meta_search.
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
        #   # Customize the column name
        #   actions :name => "Operations"
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
        #   index do
        #     status_tag :state
        #   end
        #
        #   index do
        #     status_tag "State", :status_name
        #   end
        #
        #   index do
        #     status_tag do |post|
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
