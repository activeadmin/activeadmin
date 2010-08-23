require 'inherited_views'
require 'active_admin/pages'

module ActiveAdmin
  class AdminController < ::InheritedViews::Base

    # Add our views to the view path
    ActionController::Base.append_view_path File.expand_path('../views', __FILE__)
    self.default_views = 'active_admin_default'
    
    helper ::ActiveAdmin::ViewHelpers

    layout 'active_admin'
    
    class_inheritable_accessor :form_config

    include ActiveAdmin::Breadcrumbs
    include ActiveAdmin::Sidebar
    include ActiveAdmin::ActionItems
    include ActiveAdmin::Filters
    include ActiveAdmin::ActionBuilder

    add_breadcrumb "Dashboard", "/admin"
    before_filter :add_section_breadcrumb
    def add_section_breadcrumb
      add_breadcrumb active_admin_config.plural_resource_name, collection_path 
    end

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    before_filter :setup_pagination_for_csv

    class << self
      # Reference to the Resource object which initialized
      # this controller
      attr_accessor :active_admin_config
      
      def active_admin_config=(config)
        @active_admin_config = config
        defaults :resource_class => config.resource
      end

      def set_page_config(page, config)
        active_admin_config.page_configs[page] = config
      end

      def get_page_config(page)
        active_admin_config.page_configs[page]
      end

      def reset_page_config!(page)
        active_admin_config.page_configs[page] = nil
      end


      # Setting the menu options
      def menu(options = {})
        active_admin_config.menu(options)
      end

      # Scope this controller to some object which has a relation
      # to the resource. Can either accept a block or a symbol 
      # of a method to call.
      #
      # Eg:
      #
      #   ActiveAdmin.register Post do
      #     scope_to :current_user
      #   end
      #
      # Then every time we instantiate and object, it would call
      #   
      #   current_user.posts.build
      #
      # By default Active Admin will use the resource name to build a
      # method to call as the association. If its different, you can 
      # pass in the association_method as an option.
      #
      #   scope_to :current_user, :association_method => :blog_posts
      #
      # will result in the following
      # 
      #   current_user.blog_posts.build
      #
      def scope_to(*args, &block)
        options = args.extract_options!
        method = args.first

        active_admin_config.scope_to = block_given? ? block : method
        active_admin_config.scope_to_association_method = options[:association_method]
      end
     
      #
      # Index Config
      #

      # Configure the index page for the resource
      def index(options = {}, &block)
        options[:as] ||= :table
        set_page_config :index, ActiveAdmin::PageConfig.new(options, &block)
      end

      # Configure the show page for the resource
      def show(options = {}, &block)
        set_page_config :show, ActiveAdmin::PageConfig.new(options, &block)
      end

      # Define the getting and re-setter for each configurable page
      [:index, :show].each do |page|
        # eg: index_config
        define_method :"#{page}_config" do
          get_page_config(page)
        end

        # eg: reset_index_config!
        define_method :"reset_#{page}_config!" do
          reset_page_config! page
        end
      end


      #
      # Form Config
      #

      def form(options = {}, &block)
        options[:block] = block
        self.form_config = options
      end

      def form_config
        read_inheritable_attribute(:form_config) || default_form_config
      end

      def reset_form_config!
        self.form_config = nil
      end

      def default_form_config
        config = {}
        config[:block] = lambda do |f|
          f.inputs
          f.buttons
        end
        config
      end
      
    end

    # Default Sidebar Sections
    sidebar :filters, :only => :index do
      active_admin_filters_form_for @search, filters_config
    end

    # Default Action Item Links
    action_item :only => :show do
      if controller.public_methods.include?('edit')
        link_to "Edit #{active_admin_config.resource_name}", edit_resource_path(resource)
      end
    end

    action_item :except => :new do
      if controller.public_methods.include?('new')
        link_to "New #{active_admin_config.resource_name}", new_resource_path
      end
    end

    #
    # Actions
    #
    
    def index
      index! do |format|
        format.html { render_or_default 'index' }
        format.csv { 
          @csv_columns = resource_class.columns.collect{ |column| column.name.to_sym }
          render_or_default 'index' 
        }
      end
    end
        
    private

    def collection
      get_collection_ivar || set_collection_ivar(active_admin_collection)
    end

    def active_admin_collection
      chain = scoped_collection
      chain = sort_order(chain)
      chain = search(chain)
      chain = paginate(chain)
      chain
    end

    # Override this method in your controllers to modify the start point
    # of our searches and index.
    #
    # This method should return an ActiveRecord::Relation object so that
    # the searching and filtering can be applied on top
    def scoped_collection
      end_of_association_chain
    end

    def begin_of_association_chain
      return nil unless active_admin_config.scope_to
      case active_admin_config.scope_to
      when Proc
        instance_eval &active_admin_config.scope_to
      when Symbol
        send active_admin_config.scope_to
      else
        raise ArgumentError, "#scope_to accepts a symbol or a block"
      end
    end

    # Overriding from InheritedResources::BaseHelpers
    #
    # Returns the method for the association chain when using
    # the scope_to option
    def method_for_association_chain
      active_admin_config.scope_to_association_method || super
    end

    # Allow more records for csv files
    def setup_pagination_for_csv
      @per_page = 10_000 if request.format == 'text/csv'
    end

    def paginate(chain)
      chain.paginate(:page => params[:page], :per_page => @per_page || ActiveAdmin.default_per_page)
    end

    def sort_order(chain)
      params[:order] ||= active_admin_config.sort_order
      if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
        chain.order("#{$1} #{$2}")
      else
        chain # just return the chain
      end
    end

    def search(chain)
      @search = chain.search(clean_search_params(params[:q]))
    end

    def clean_search_params(search_params)
      return {} unless search_params.is_a?(Hash)
      search_params = search_params.dup
      search_params.delete_if do |key, value|
        value == ""
      end
      search_params
    end

    def active_admin_config
      self.class.active_admin_config
    end
    helper_method :active_admin_config

    def index_config
      @index_config ||= self.class.index_config
    end
    helper_method :index_config

    def show_config
      @show_config ||= self.class.show_config
    end
    helper_method :show_config

    def form_config
      @form_config ||= self.class.form_config
    end
    helper_method :form_config

    # Returns the renderer class to use for the given action.
    #
    # TODO: This needs to be wrapped into a default config as well
    # as overrideable on each controller
    def renderer_for(action)
      {
        :index  => ::ActiveAdmin::Pages::Index,
        :new    => ::ActiveAdmin::Pages::New,
        :show   => ::ActiveAdmin::Pages::Show,
        :edit   => ::ActiveAdmin::Pages::Edit
      }[action]
    end
    helper_method :renderer_for

  end
end
