# frozen_string_literal: true
ActiveAdmin::Dependency.kaminari!

require "kaminari"

module ActiveAdmin

  # Active Admin's Kaminari pagination adapter.
  # This adapter paginates using Kaminari and provides page info.
  class KaminariAdapter < PaginationAdapter
    def paginate(collection, page: nil, per_page: nil)
      collection.public_send(page_method_name, page).per(per_page)
    end

    def paginated?(collection)
      collection.respond_to?(:total_pages)
    end

    def page_param_name
      Kaminari.config.param_name
    end

    private

    def page_method_name
      Kaminari.config.page_method_name
    end
  end
end
