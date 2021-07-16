# frozen_string_literal: true
module ActiveAdmin
  # This is the class where all the register blocks are evaluated.
  class ResourceDSL < DSL

    private

    # Redefine sort behaviour for column
    #
    # For example:
    #
    #   # nulls last
    #   order_by(:age) do |order_clause|
    #     [order_clause.to_sql, 'NULLS LAST'].join(' ')  if order_clause.order == 'desc'
    #   end
    #
    #   # by last_name but in the case that there is no last name, by first_name.
    #   order_by(:full_name) do |order_clause|
    #     ['COALESCE(NULLIF(last_name, ''), first_name), first_name', order_clause.order].join(' ')
    #   end
    #
    #
    def order_by(column, &block)
      config.ordering[column] = block
    end

    def belongs_to(target, options = {})
      config.belongs_to(target, options)
    end

    # Scope collection to a relation
    def scope_to(*args, &block)
      config.scope_to(*args, &block)
    end

    # Create a scope
    def scope(*args, &block)
      config.scope(*args, &block)
    end

    # Store relations that should be included
    def includes(*args)
      config.includes.push *args
    end

    #
    # Keys included in the `permitted_params` setting are automatically whitelisted.
    #
    # Either
    #
    #   permit_params :title, :author, :body, tags: []
    #
    # Or
    #
    #   permit_params do
    #     defaults = [:title, :body]
    #     if current_user.admin?
    #       defaults + [:author]
    #     else
    #       defaults
    #     end
    #   end
    #
    def permit_params(*args, &block)
      param_key = config.param_key.to_sym

      controller do
        define_method :permitted_params do
          belongs_to_param = active_admin_config.belongs_to_param
          create_another_param = :create_another if active_admin_config.create_another

          permitted_params =
            active_admin_namespace.permitted_params +
              Array.wrap(belongs_to_param) +
              Array.wrap(create_another_param)

          params.permit(*permitted_params, param_key => block ? instance_exec(&block) : args)
        end

        private :permitted_params
      end
    end

    # Configure the index page for the resource
    def index(options = {}, &block)
      options[:as] ||= :table
      config.set_page_presenter :index, ActiveAdmin::PagePresenter.new(options, &block)
    end

    # Configure the show page for the resource
    def show(options = {}, &block)
      config.set_page_presenter :show, ActiveAdmin::PagePresenter.new(options, &block)
    end

    def form(options = {}, &block)
      config.set_page_presenter :form, ActiveAdmin::PagePresenter.new(options, &block)
    end

    # Configure the CSV format
    #
    # For example:
    #
    #   csv do
    #     column :name
    #     column("Author") { |post| post.author.full_name }
    #   end
    #
    #   csv col_sep: ";", force_quotes: true do
    #     column :name
    #   end
    #
    def csv(options = {}, &block)
      options[:resource] = config

      config.csv_builder = CSVBuilder.new(options, &block)
    end

    # Member Actions give you the functionality of defining both the
    # action and the route directly from your ActiveAdmin registration
    # block.
    #
    # For example:
    #
    #   ActiveAdmin.register Post do
    #     member_action :comments do
    #       @post = Post.find(params[:id])
    #       @comments = @post.comments
    #     end
    #   end
    #
    # Will create a new controller action comments and will hook it up to
    # the named route (comments_admin_post_path) /admin/posts/:id/comments
    #
    # You can treat everything within the block as a standard Rails controller
    # action.
    #
    def action(set, name, options = {}, &block)
      warn "Warning: method `#{name}` already defined in #{controller.name}" if controller.method_defined?(name)

      set << ControllerAction.new(name, options)
      title = options.delete(:title)

      controller do
        before_action(only: [name]) { @page_title = title } if title
        define_method(name, &block || Proc.new {})
      end
    end

    def member_action(name, options = {}, &block)
      action config.member_actions, name, options, &block
    end

    def collection_action(name, options = {}, &block)
      action config.collection_actions, name, options, &block
    end

    def decorate_with(decorator_class)
      # Force storage as a string. This will help us with reloading issues.
      # Assuming decorator_class.to_s will return the name of the class allows
      # us to handle a string or a class.
      config.decorator_class_name = "::#{ decorator_class }"
    end

    # Defined Callbacks
    #
    # == After Build
    # Called after the resource is built in the new and create actions.
    #
    # ActiveAdmin.register Post do
    #   after_build do |post|
    #     post.author = current_user
    #   end
    # end
    #
    # == Before / After Create
    # Called before and after a resource is saved to the db on the create action.
    #
    # == Before / After Update
    # Called before and after a resource is saved to the db on the update action.
    #
    # == Before / After Save
    # Called before and after the object is saved in the create and update action.
    # Note: Gets called after the create and update callbacks
    #
    # == Before / After Destroy
    # Called before and after the object is destroyed from the database.
    #
    delegate :before_build, :after_build, to: :controller
    delegate :before_create, :after_create, to: :controller
    delegate :before_update, :after_update, to: :controller
    delegate :before_save, :after_save, to: :controller
    delegate :before_destroy, :after_destroy, to: :controller

    standard_rails_filters =
      AbstractController::Callbacks::ClassMethods.public_instance_methods.select { |m| m.match(/_action\z/) }
    delegate *standard_rails_filters, to: :controller

    # Specify which actions to create in the controller
    #
    # Eg:
    #
    #   ActiveAdmin.register Post do
    #     actions :index, :show
    #   end
    #
    # Will only create the index and show actions (no create, update or delete)
    delegate :actions, to: :controller

  end
end
