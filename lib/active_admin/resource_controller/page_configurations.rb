module ActiveAdmin
  class ResourceController < BaseController

    module PageConfigurations
      extend ActiveSupport::Concern

      included do
        helper_method :index_config
        helper_method :show_config
      end

      module ClassMethods

        def set_page_config(page, options, &block)
          active_admin_config.page_configs[page] = ActiveAdmin::PageConfig.new(options, &block)
        end

        def get_page_config(page)
          active_admin_config.page_configs[page]
        end

        def reset_page_config!(page)
          active_admin_config.page_configs[page] = nil
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
