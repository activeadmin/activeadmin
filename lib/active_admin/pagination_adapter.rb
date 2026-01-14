# frozen_string_literal: true
module ActiveAdmin

  # Active Admin's default pagination adapter. This adapter returns the full
  # collection and disables pagination. It should be the starting point for
  # implementing your own pagination adapter.
  #
  # To view an example subclass, check out `ActiveAdmin::KaminariAdapter`
  class PaginationAdapter
    attr_reader :resource

    # Initialize a new pagination adapter. This happens on each and
    # every request to a controller.
    #
    # @param [ActiveAdmin::Resource, ActiveAdmin::Page] resource The resource
    #        that the user is currently on.
    #
    def initialize(resource)
      @resource = resource
    end

    # Paginate a collection.
    #
    # @param [Enumerable] collection The collection to paginate.
    # @param [Integer, nil] page Optional page number override.
    # @param [Integer, nil] per_page Optional per-page override.
    #
    # @return [Enumerable] The paginated collection
    def paginate(collection, page: nil, per_page: nil)
      collection
    end

    # Indicates whether the given collection has already been paginated.
    #
    # Subclasses should override this method to return true if the collection
    # has already been paginated (e.g., by a scope or external engine),
    # to prevent double pagination. This is used to skip pagination logic
    # when the collection is already paginated.
    #
    # @param [Enumerable] collection The collection to check for pagination.
    #
    # @return [Boolean] true if the collection is already paginated, false otherwise.
    def paginated?(collection)
      false
    end

    # Default page param name; adapters can override to integrate with engines.
    def page_param_name
      :page
    end
  end
end
