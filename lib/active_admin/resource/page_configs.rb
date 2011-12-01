module ActiveAdmin
  class Resource
    module PageConfigs

      # A hash of page configurations for the controller indexed by action name
      def page_configs
        @page_configs ||= {}
      end

      # Sets a page config for a given action
      #
      def add_page_config(action, page_config)
        page_configs[action.to_sym] = page_config
      end

      def get_page_config(action)
        page_configs[action.to_sym]
      end

    end
  end
end
