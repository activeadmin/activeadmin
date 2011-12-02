module ActiveAdmin
  class Resource
    module PagePresenters

      # A hash of page configurations for the controller indexed by action name
      def page_presenters
        @page_presenters ||= {}
      end

      # Sets a page config for a given action
      #
      # @param [String, Symbol] action The action to store this configuration for
      # @param [PagePresenter] page_presenter The instance of PagePresenter to store
      def set_page_presenter(action, page_presenter)
        page_presenters[action.to_sym] = page_presenter
      end

      # Returns a stored page config
      #
      # @param [Symbol, String] action The action to get the config for
      # @returns [PagePresenter, nil]
      def get_page_presenter(action)
        page_presenters[action.to_sym]
      end

    end
  end
end
