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

        # if action is 'index' and the the caller is a resource
        if action.to_s == "index" && page_presenter[:as]
          case page_presenter[:as]
          when Symbol
            index_class = ::ActiveAdmin::Views.const_get("IndexAs" + page_presenter[:as].to_s.camelcase)
          when Class
            index_class = page_presenter[:as]
          end

          set_index_presenter index_class, page_presenter
        else
          # if action is anything other than index or if the caller is a page
          page_presenters[action.to_sym] = page_presenter
        end
      end

      # Stores a config for all index actions supplied
      #
      # @param [Symbol] index_as The index type to store in the configuration
      # @param [PagePresenter] page_presenter The intance of PagePresenter to store
      def set_index_presenter(index_as, page_presenter)
        page_presenters[:index] ||= {}

        #set first index as default value or the index with default param set to to true
        if page_presenters[:index].empty? || page_presenter[:default] == true
          page_presenters[:index].default = page_presenter
        end

        page_presenters[:index][index_as] = page_presenter
      end

      # Returns a stored page config
      #
      # @param [Symbol, String] action The action to get the config for
      # @returns [PagePresenter, nil]
      def get_page_presenter(action, type=nil)
        # have to convert the passed in type to the class so that i can 

        # p "!!! in #get_page_presenter"
        # p type
        # p page_presenters[:index]
        if action.to_s == "index" && type && page_presenters[:index].kind_of?(Hash)
          page_presenters[:index][type.to_sym] 
        elsif action.to_s == "index" && page_presenters[:index].kind_of?(Hash)
          page_presenters[:index].default
        else
          page_presenters[action.to_sym]
        end
      end

    end
  end
end
