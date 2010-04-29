require 'inherited_views'

module ActiveAdmin
	class AdminController < InheritedViews::Base
  
    # Add our views to the view path
    ActionController::Base.append_view_path File.expand_path('../views', __FILE__)
    self.default_views = 'active_admin_default'
    
    helper ::ActiveAdmin::ViewHelpers

    layout 'active_admin'
    
    class_inheritable_accessor :index_config
    class_inheritable_accessor :form_config

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


      #
      # Form Config
      #

      def form(options = {}, &block)
        self.form_config = FormBuilder.new(&block)
      end

      def form_config
        read_inheritable_attribute(:form_config) || default_form_config
      end

      def reset_form_config!
        self.form_config = nil
      end

      def default_form_config
        FormBuilder.new do |f|
          f.inputs
          f.buttons
        end
      end
 
    end
    
        
    private
    
    def index_config
      @index_config ||= self.class.index_config
    end
    helper_method :index_config

    def form_config
      @form_config ||= self.class.form_config
    end
    helper_method :form_config

	end
end
