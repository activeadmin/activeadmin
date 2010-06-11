require 'inherited_views'

module ActiveAdmin
  class AdminController < ::InheritedViews::Base
  
    # Add our views to the view path
    ActionController::Base.append_view_path File.expand_path('../views', __FILE__)
    self.default_views = 'active_admin_default'
    
    helper ::ActiveAdmin::ViewHelpers

    layout 'active_admin'
    
    class_inheritable_accessor :index_config
    class_inheritable_accessor :form_config
    
    class_inheritable_accessor :active_admin_config
    self.active_admin_config = {
      :per_page => 50,
      :default_sort_order => 'id_desc'
    }

    
    include ::ActiveAdmin::Breadcrumbs

    add_breadcrumb "Dashboard", "/admin"
    before_filter :add_section_breadcrumb
    def add_section_breadcrumb
      add_breadcrumb resources_name, collection_path 
    end

    respond_to :html, :xml, :json
    respond_to :csv, :only => :index

    before_filter :setup_pagination_for_csv

    class << self
     
      #
      # Index Config
      #

      # Configure the index page for the resource
      def index(options = {}, &block)
        options[:as] ||= TableBuilder
        self.index_config = options[:as].new(&block)
      end

      def index_config
        read_inheritable_attribute(:index_config) || default_index_config
      end
      
      def reset_index_config!
        self.index_config = nil
      end

      def default_index_config
        TableBuilder.new do |display|
          resource_class.content_columns.each do |column|
            display.column column.name.to_sym
          end
          display.default_actions
        end
      end

      def default_per_page=(per_page)
        read_inheritable_attribute(:active_admin_config)[:per_page] = per_page
      end

      def default_per_page
        read_inheritable_attribute(:active_admin_config)[:per_page]
      end


      #
      # Filters Sidebar Configuration
      #

      def filter(attribute, options = {})
        return false if attribute.nil?
        @filters ||= []
        @filters << options.merge(:attribute => attribute)
      end

      def filters_config
        @filters && @filters.any? ? @filters : default_filters_config
      end

      def reset_filters!
        @filters = []
      end

      def default_filters_config
        resource_class.columns.collect{|c| { :attribute => c.name.to_sym } }
      end


      #
      # Form Config
      #

      def form(options = {}, &block)
        self.form_config = block
      end

      def form_config
        read_inheritable_attribute(:form_config) || default_form_config
      end

      def reset_form_config!
        self.form_config = nil
      end

      def default_form_config
        lambda do |f|
          f.inputs
          f.buttons
        end
      end


      #
      # Naming
      #

      def resource_name(name)
        if name.nil?
          get_resource_name
        else
          set_resource_name(name)
        end
      end
      
      def set_resource_name(name)
        self.active_admin_config[:resource_name] = name
      end
      
      def get_resource_name
        self.active_admin_config[:resource_name] ||= resource_class.human_name.titleize
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

    # Allow more records for csv files
    def setup_pagination_for_csv
      @per_page = 10_000 if request.format == 'text/csv'
    end

    def paginate(chain)
      chain.paginate(:page => params[:page], :per_page => @per_page || self.class.default_per_page)
    end

    def sort_order(chain)
      params[:order] ||= active_admin_config[:default_sort_order]
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

    def filters_config
      self.class.filters_config
    end
    helper_method :filters_config
    
    def index_config
      @index_config ||= self.class.index_config
    end
    helper_method :index_config

    def form_config
      @form_config ||= self.class.form_config
    end
    helper_method :form_config
    
    def resource_name
      self.class.get_resource_name
    end
    helper_method :resource_name

  end
end
