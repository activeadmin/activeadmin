module ActiveAdmin
  class ResourceController < ::InheritedViews::Base
    
    module PageConfigurations
      extend ActiveSupport::Concern

      included do
        helper_method :index_config
        helper_method :show_config
      end

      module ClassMethods

        def set_page_config(page, config)
          active_admin_config.page_configs[page] = config
        end

        def get_page_config(page)
          active_admin_config.page_configs[page]
        end

        def reset_page_config!(page)
          active_admin_config.page_configs[page] = nil
        end

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

      end

      protected

      def index_config
        @index_config ||= self.class.index_config
      end

      def show_config
        @show_config ||= self.class.show_config
      end

    end
  end
end
