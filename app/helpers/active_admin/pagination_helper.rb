# frozen_string_literal: true
module ActiveAdmin
  # Pagination helper methods for ActiveAdmin
  # Requires IndexHelper to be included for collection_size and collection_empty? methods
  module PaginationHelper
    # ActiveAdmin's wrapper for paginate method
    # Delegates to Kaminari's paginate helper
    def active_admin_paginate(collection, options = {})
      paginate(collection, **options)
    end

    # ActiveAdmin's page entries info implementation
    # Modified from will_paginate
    def active_admin_page_entries_info(collection, options = {})
      if options[:entry_name]
        entry_name = options[:entry_name]
        entries_name = options[:entries_name] || entry_name.pluralize
      elsif collection_empty?(collection)
        entry_name = I18n.t "active_admin.pagination.entry", count: 1, default: "entry"
        entries_name = I18n.t "active_admin.pagination.entry", count: 2, default: "entries"
      else
        key = "activerecord.models." + collection.first.class.model_name.i18n_key.to_s

        entry_name = I18n.translate key, count: 1, default: collection.first.class.name.underscore.sub("_", " ")
        entries_name = I18n.translate key, count: collection.size, default: entry_name.pluralize
      end

      display_total = options.fetch(:pagination_total, true)

      if display_total
        if collection.total_pages < 2
          case collection_size(collection)
          when 0; I18n.t("active_admin.pagination.empty", model: entries_name)
          when 1; I18n.t("active_admin.pagination.one", model: entry_name)
          else; I18n.t("active_admin.pagination.one_page", model: entries_name, n: collection.total_count)
          end
        else
          offset = (collection.current_page - 1) * collection.limit_value
          total = collection.total_count
          I18n.t "active_admin.pagination.multiple",
                 model: entries_name,
                 total: total,
                 from: offset + 1,
                 to: offset + collection_size(collection)
        end
      else
        # Do not display total count, in order to prevent a `SELECT count(*)`.
        # To do so we must not call `collection.total_pages`
        offset = (collection.current_page - 1) * collection.limit_value
        I18n.t "active_admin.pagination.multiple_without_total",
               model: entries_name,
               from: offset + 1,
               to: offset + collection_size(collection)
      end
    end
  end
end
