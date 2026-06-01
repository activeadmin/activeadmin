# frozen_string_literal: true

# A non-ActiveRecord resource used in features to demonstrate that
# ActiveAdmin's filter DSL renders for resources that bypass the AR
# DataAccess path — HTTP-backed wrappers, SQL query objects, in-memory
# aggregations, etc.
#
# Pagination is owned by the model — `.fetch` returns the requested page
# plus total_count/limit/offset metadata, mirroring the shape an HTTP
# API client would carry alongside the page payload (response headers,
# meta blocks, cursors — wherever the upstream API surfaces the total).
# The controller then adapts that response for AA's UI via
# `Kaminari.paginate_array(records, total_count: ...)`.
class ApiPost
  extend ActiveModel::Naming

  Record = Struct.new(:id, :title, :status, keyword_init: true)

  # Lightweight `@search` wrapper. ActiveAdmin's filter form pre-fills
  # input values via `@search.<filter_name>`, so this needs attribute
  # readers for every declared filter — Struct gives us that with no
  # OpenStruct dependency.
  Search = Struct.new(:title_cont, :status_eq, keyword_init: true)

  ALL_RECORDS = [
    Record.new(id: 1, title: "Alpha", status: "active"),
    Record.new(id: 2, title: "Beta", status: "inactive"),
    Record.new(id: 3, title: "Gamma", status: "active"),
    Record.new(id: 4, title: "Delta", status: "active"),
    Record.new(id: 5, title: "Epsilon", status: "inactive"),
    Record.new(id: 6, title: "Zeta", status: "active"),
    Record.new(id: 7, title: "Eta", status: "active")
  ].freeze

  # Response shape mirrors what a real API client returns: the page of
  # records plus the total_count reported by the upstream API — so the
  # controller can hand AA's pagination UI an accurate total without
  # loading every record.
  Result = Struct.new(:records, :total_count, :limit, :offset, keyword_init: true)

  def self.fetch(page: 1, per_page: 5, title_cont: nil, status_eq: nil)
    page = [page.to_i, 1].max
    per_page = per_page.to_i

    records = ALL_RECORDS
    records = records.select { |r| r.title.include?(title_cont) } if title_cont.present?
    records = records.select { |r| r.status == status_eq } if status_eq.present?

    offset = (page - 1) * per_page

    Result.new(
      records: records[offset, per_page] || [],
      total_count: records.size,
      limit: per_page,
      offset: offset
    )
  end
end
