# frozen_string_literal: true
module ActiveAdmin

  # Active Admin's default pagination adapter. This adapter returns the full
  # collection and disables pagination. It should be the starting point for
  # implementing your own pagination adapter.
  #
  # To view an example subclass, check out `ActiveAdmin::KaminariAdapter`
  class PaginationAdapter
    attr_reader :resource, :params

    # Initialize a new pagination adapter. This happens on each and
    # every request to a controller.
    #
    # @param [ActiveAdmin::Resource, ActiveAdmin::Page] resource The resource
    #        that the user is currently on.
    #
    # @param [Hash] params The current request params.
    #
    def initialize(resource, params)
      @resource = resource
      @params = params
    end

    # Paginate a collection.
    #
    # @param [Enumerable] collection The collection to paginate.
    # @param [Integer,nil] page Optional page number override.
    # @param [Integer,nil] per_page Optional per-page override.
    #
    # @return [Enumerable] The paginated collection (or original if not paginating).
    def paginate(collection, page: nil, per_page: nil)
      # Base adapter does not paginate, simply returns the normalized collection
      normalized(collection)
    end

    # Returns false, as this adapter does not paginate.
    #
    # @param [Enumerable] collection
    #
    # @return [Boolean]
    def paginated?(collection)
      false
    end

    private

    # The `#paginate` method's collection can be set to both arrays as well
    # as ActiveRecord relations. This method can be overridden in subclasses
    # to provide custom pagination logic.
    def normalized(collection)
      collection
    end

    # Lookup the requested page from params or use a sane default.
    # Subclasses may override `#page_param_name` to adapt to the underlying engine.
    def page_value(override)
      override || params[page_param_name] || 1
    end

    # Compute the per_page value considering resource settings and request params.
    # Respect disabled pagination by using max_per_page when resource.paginate is false.
    def per_page_value(override)
      return override if override

      if resource.paginate
        requested = params[:per_page] || Array(resource.per_page).first
        requested.to_i
      else
        resource.max_per_page.to_i
      end
    end

    # Default page param name; adapters can override to integrate with engines.
    def page_param_name
      :page
    end
  end
end
