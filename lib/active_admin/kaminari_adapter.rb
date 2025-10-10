# frozen_string_literal: true
module ActiveAdmin

  # Active Admin's Kaminari pagination adapter.
  # This adapter paginates using Kaminari and provides page info.
  class KaminariAdapter < PaginationAdapter
    def paginate(collection, page: nil, per_page: nil)
      page_method_name = Kaminari.config.page_method_name
      page_no = page_value(page)
      size = per_page_value(per_page)

      normalized(collection).public_send(page_method_name, page_no).per(size)
    end

    def paginated?(collection)
      collection.respond_to?(:current_page) && collection.respond_to?(:total_pages)
    end

    private

    def page_param_name
      Kaminari.config.param_name
    end
  end
end
