require 'inherited_views'

module ActiveAdmin
	class BaseController < InheritedViews::Base
  
    # Add our views to the view path
    ActionController::Base.append_view_path File.expand_path('../views', __FILE__)
    self.default_views = 'active_admin_default'
    
    class_inheritable_accessor :index_config
    
    helper ::ActiveAdmin::ViewHelpers
    
    class << self
      
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
        end
      end
    end
    
        
    private
    
    def index_config
      @index_config ||= self.class.index_config
    end
    helper_method :index_config

	end
end
