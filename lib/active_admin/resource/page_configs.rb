module ActiveAdmin
  class Resource
    module PageConfigs

      # A hash of page configurations for the controller indexed by action name
      def page_configs
        @page_configs ||= {}
      end

      # Sets a page config for a given action
      #
      # @param [String, Symbol] action The action to store this configuration for
      # @param [PageConfig] page_config The instance of PageConfig to store
      def set_page_config(action, page_config)
        page_configs[action.to_sym] = page_config
      end

      # Returns a stored page config
      #
      # @param [Symbol, String] action The action to get the config for
      # @returns [PageConfig, nil]
      def get_page_config(action)
        page_configs[action.to_sym]
      end

    end
  end
end
