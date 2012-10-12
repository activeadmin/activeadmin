module ActiveAdmin
  class Resource
    module PagePresenters

      # A hash of page configurations for the controller indexed by action name
      def page_presenters
        @page_presenters ||= {}
      end

      # A hash of index configurations - test
      def index_presenters
        @index_presenters ||= {}
      end

      # Sets a page config for a given action
      #
      # @param [String, Symbol] action The action to store this configuration for
      # @param [PagePresenter] page_presenter The instance of PagePresenter to store
      def set_page_presenter(action, page_presenter)
        p "hello"
        presenter = page_presenters[:index]
        if action.to_s != "index" || action.to_s == "index" && !presenter || action.to_s == "index" && presenter[:default] != true
          page_presenters[action.to_sym] = page_presenter
        end
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
