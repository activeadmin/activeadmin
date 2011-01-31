module ActiveAdmin
  class ResourceController < ::InheritedViews::Base

    # All the controller actions are defined here. They all use
    # the render_or_default method provided by InheritedViews which
    # tries to render the view in the user's application, then falls
    # back the view declared by Active Admin.
    module Actions
      def index
        index! do |format|
          format.html do
            render_or_default 'index'
          end
          format.csv do 
            @csv_columns = resource_class.columns.collect{ |column| column.name.to_sym }
            render_or_default 'index' 
          end
        end
      end

      def new
        new! do |format|
          format.html { render_or_default 'new' }
        end
      end
      
      def create
        create! do |success, failure|
          failure.html { render_or_default 'new' }
        end
      end
      
      def show
        show! do |format|
          format.html { render_or_default 'show' }
        end
      end
      
      def edit
        edit! do |format|
          format.html { render_or_default 'edit' }
        end
      end
      
      def update
        update! do |success, failure|
          failure.html { render_or_default 'edit' }
        end
      end
    end

  end
end
