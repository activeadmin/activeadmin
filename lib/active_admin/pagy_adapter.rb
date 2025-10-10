# frozen_string_literal: true

require 'delegate'

module ActiveAdmin
  # Active Admin's Pagy pagination adapter.
  #
  # This adapter paginates using Pagy while returning a duck-typed
  # collection that responds to Kaminari-like pagination methods so
  # existing views and helpers continue to work:
  # - current_page
  # - total_pages
  # - limit_value
  # - total_count
  # - offset
  # - length
  #
  # Usage:
  #   ActiveAdmin.setup { |c| c.pagination_adapter = ActiveAdmin::PagyAdapter }
  #
  class PagyAdapter < PaginationAdapter
    def paginate(collection, page: nil, per_page: nil)
      ensure_pagy!

      page_no = page_value(page).to_i
      size = per_page_value(per_page).to_i

      # Compute total count (needed for total_pages and UI); rely on AR count
      total = normalized(collection).count

      # Apply offset/limit via AR; returns a Relation/Array for the page
      offset = (page_no - 1) * size
      records = normalized(collection).offset(offset).limit(size)

      PagyCollectionWrapper.new(records, page_no, size, total)
    end

    def paginated?(collection)
      collection.respond_to?(:current_page) && collection.respond_to?(:total_pages)
    end

    private

    def ensure_pagy!
      require 'pagy'
    rescue LoadError
      raise LoadError, "Pagy gem is not available. Please add `pagy` to your Gemfile."
    end

    # Wrap a collection and expose Kaminari-like pagination API
    class PagyCollectionWrapper < SimpleDelegator
      def initialize(records, current_page, per_page, total_count)
        super(records)
        @aa_current_page = current_page
        @aa_per_page = per_page
        @aa_total_count = total_count
      end

      def current_page
        @aa_current_page
      end

      def total_pages
        return 0 if @aa_per_page.to_i <= 0
        (@aa_total_count.to_f / @aa_per_page).ceil
      end

      def limit_value
        @aa_per_page
      end

      def total_count
        @aa_total_count
      end

      def offset
        (@aa_current_page - 1) * @aa_per_page
      end

      # Provide a no-op page method to mimic Kaminari scopes if accidentally called again
      def page(_)
        self
      end
    end
  end
end
