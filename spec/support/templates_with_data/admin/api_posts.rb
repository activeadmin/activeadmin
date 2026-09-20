# frozen_string_literal: true
ActiveAdmin.register ApiPost do
  menu label: "PORO Posts"
  actions :index

  # Active-filter chips require a Ransack search, unlike the filter form.
  config.current_filters = false

  filter :title_cont, as: :string, label: "Title contains"
  filter :status_eq, as: :select, label: "Status", collection: %w[active inactive]

  index title: "PORO Posts", download_links: false do
    column :id, sortable: false
    column :title, sortable: false
    column :status, sortable: false
  end

  controller do
    protected

    # Non-ActiveRecord resources override `find_collection`; Kaminari.paginate_array
    # adapts the API response for ActiveAdmin's pagination UI.
    def find_collection(*)
      q = params[:q] || {}
      @search = ApiPost::Search.new(
        title_cont: q[:title_cont],
        status_eq: q[:status_eq]
      )
      page = (params[:page] || 1).to_i
      per_page = 5

      result = ApiPost.fetch(
        page: page,
        per_page: per_page,
        title_cont: @search.title_cont,
        status_eq: @search.status_eq
      )

      Kaminari.paginate_array(
        result.records,
        total_count: result.total_count,
        limit: result.limit,
        offset: result.offset
      ).page(page).per(per_page)
    end
  end
end
