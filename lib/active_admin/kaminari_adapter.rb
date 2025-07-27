# frozen_string_literal: true
module ActiveAdmin

  # Active Admin's Kaminari pagination adapter.
  # This adapter paginates using Kaminari and provides page info.
  class KaminariAdapter < PaginationAdapter
    def paginate(collection)
      # Assumes collection is already a Kaminari paginated scope
      collection
    end

    def paginated?(collection)
      collection.respond_to?(:current_page) && collection.respond_to?(:total_pages)
    end
  end
end
