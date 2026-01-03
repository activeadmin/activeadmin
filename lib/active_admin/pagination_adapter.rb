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

    # Default page param name; adapters can override to integrate with engines.
    def page_param_name
      :page
    end

    private

    # The `#paginate` method's collection can be set to both arrays as well
    # as ActiveRecord relations. This method can be overridden in subclasses
    # to provide custom pagination logic.
    def normalized(collection)
      collection
    end
  end
end
