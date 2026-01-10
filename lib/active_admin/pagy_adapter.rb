# frozen_string_literal: true
ActiveAdmin::Dependency.pagy! ActiveAdmin::Dependency::Requirements::PAGY

require "pagy"

module ActiveAdmin
  # Active Admin's Pagy pagination adapter.
  #
  # This adapter paginates using Pagy while returning a duck-typed
  # collection that responds to Kaminari-like pagination methods so
  # existing views and helpers continue to work.
  class PagyAdapter < PaginationAdapter
    include Pagy::Method

    def paginate(collection, page: nil, per_page: nil)
      pagy_instance, records = pagy(
        collection, request: {
          params: { page: page, limit: per_page }
        }, page_key: :page, limit_key: :limit, client_max_limit: per_page, jsonapi: false)

      PaginatedScope.new(pagy_instance, records)
    end

    def paginated?(collection)
      collection.respond_to?(:current_page) && collection.respond_to?(:total_pages)
    end

    class PaginatedScope < SimpleDelegator
      def initialize(pagy, records)
        super(records)
        @pagy = pagy
      end

      def current_page
        pagy.page
      end

      def total_pages
        pagy.pages
      end

      def limit_value
        pagy.limit
      end

      def total_count
        pagy.count
      end

      def offset
        pagy.offset
      end

      # Provide a no-op page method to mimic Kaminari scopes if accidentally called again
      def page(_)
        self
      end

      private

      attr_reader :pagy
    end
  end
end
