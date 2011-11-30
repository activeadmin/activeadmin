module ActiveAdmin
  class Resource
    module PageConfigs

      # A hash of page configurations for the controller indexed by action name
      def page_configs
        @page_configs ||= {}
      end

    end
  end
end
