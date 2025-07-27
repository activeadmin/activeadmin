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

    # Returns the collection, unpaginated.
    #
    # @param [Enumerable] collection The collection to paginate.
    #
    # @return [Enumerable] The unpaginated collection.
    def paginate(collection)
      collection
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
    end
  end
end
