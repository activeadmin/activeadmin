# frozen_string_literal: true
module ActiveAdmin
  class Resource
    module PagePresenters

      # for setting default css class in admin ui
      def default_index_class
        @default_index
      end

      # A hash of page configurations for the controller indexed by action name
      def page_presenters
        @page_presenters ||= {}
      end

      # Sets a page config for a given action
      #
      # @param [String, Symbol] action The action to store this configuration for
      # @param [PagePresenter] page_presenter The instance of PagePresenter to store
      def set_page_presenter(action, page_presenter)

        if action.to_s == "index" && page_presenter[:as]
          index_class = find_index_class(page_presenter[:as])
          page_presenter_key = index_class.index_name.to_sym
          set_index_presenter page_presenter_key, page_presenter
        else
          page_presenters[action.to_sym] = page_presenter
        end

      end

      # Returns a stored page config
      #
      # @param [Symbol, String] action The action to get the config for
      # @param [String] type The string specified in the presenters index_name method
      # @return [PagePresenter, nil]
      def get_page_presenter(action, type = nil)

        if action.to_s == "index" && type && page_presenters[:index].kind_of?(Hash)
          page_presenters[:index][type.to_sym]
        elsif action.to_s == "index" && page_presenters[:index].kind_of?(Hash)
          page_presenters[:index].default
        else
          page_presenters[action.to_sym]
        end

      end

      protected

      # Stores a config for all index actions supplied
      #
      # @param [Symbol] index_as The index type to store in the configuration
      # @param [PagePresenter] page_presenter The intance of PagePresenter to store
      def set_index_presenter(index_as, page_presenter)
        page_presenters[:index] ||= {}

        #set first index as default value or the index with default param set to to true
        if page_presenters[:index].empty? || page_presenter[:default] == true
          page_presenters[:index].default = page_presenter
          @default_index = find_index_class(page_presenter[:as])
        end

        page_presenters[:index][index_as] = page_presenter
      end

      # Returns the actual class for renderering the main content on the index
      # page. To set this, use the :as option in the page_presenter block.
      #
      # @param [Symbol, Class] symbol_or_class The component symbol or class
      # @return [Class]
      def find_index_class(symbol_or_class)
        case symbol_or_class
        when Symbol
          ::ActiveAdmin::Views.const_get("IndexAs" + symbol_or_class.to_s.camelcase)
        when Class
          symbol_or_class
        end
      end

    end
  end
end
