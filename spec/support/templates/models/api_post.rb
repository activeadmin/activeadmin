# frozen_string_literal: true

# A non-ActiveRecord resource used in features to prove ActiveAdmin's
# filter DSL works for resources that bypass the AR DataAccess path.
# `.fetch` returns a page of records plus total_count, like an HTTP API client.
class ApiPost
  extend ActiveModel::Naming

  Record = Data.define(:id, :title, :status)

  # The filter form pre-fills inputs via `@search.<filter_name>`, so this needs a reader per filter.
  Search = Data.define(:title_cont, :status_eq)

  ALL_RECORDS = [
    Record.new(id: 1, title: "Alpha", status: "active"),
    Record.new(id: 2, title: "Beta", status: "inactive"),
    Record.new(id: 3, title: "Gamma", status: "active"),
    Record.new(id: 4, title: "Delta", status: "active"),
    Record.new(id: 5, title: "Epsilon", status: "inactive"),
    Record.new(id: 6, title: "Zeta", status: "active"),
    Record.new(id: 7, title: "Eta", status: "active")
  ].freeze

  Result = Data.define(:records, :total_count, :limit, :offset)

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
