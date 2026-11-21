# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Filters on API resources", type: :system do
  before do
    login_as_admin
    register_resources do
      ActiveAdmin.register ApiPost do
        actions :index

        filter :title_cont, as: :string, label: "Title contains"
        filter :status_eq, as: :select, label: "Status",
                           collection: %w[active inactive]
        filter :title, as: :select, label: "Title (no predicate)",
                       collection: %w[foo bar]

        index do
          column :id
          column :title
          column :status
        end

        controller do
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
    end

    visit admin_api_posts_path
  end

  it "server-side pagination across multiple pages" do
    expect(page).to have_text("Alpha")
    expect(page).to have_text("Epsilon")
    expect(page).to have_no_text("Zeta")
    expect(page).to have_text("Showing 1-5 of 7")
    expect(page).to have_css("[data-test-pagination] a", exact_text: "2")
    expect(page).to have_css(".filters-form-field.string label", exact_text: "Title contains")
    expect(page).to have_css(".filters-form-field.select label", exact_text: "Status")
    expect(page).to have_css(".filters-form-field.select label", exact_text: "Title (no predicate)")

    click_link "2", exact: true

    expect(page).to have_text("Zeta")
    expect(page).to have_text("Eta")
    expect(page).to have_text("Showing 6-7 of 7")
    expect(page).to have_no_text("Alpha")
  end

  it "filter narrows the result set to a single page (no pagination)" do
    expect(page).to have_css("[data-test-pagination] a", exact_text: "2")
    select "inactive", from: "Status"
    click_button "Filter"

    expect(page).to have_text("Beta")
    expect(page).to have_text("Epsilon")
    expect(page).to have_no_text("Alpha")
    expect(page).to have_no_text("Gamma")
    expect(page).to have_text("Showing all 2")
    expect(page).to have_no_css("[data-test-pagination]")
  end

  it "filter narrows the result set to a single record" do
    fill_in "Title contains", with: "Bet"
    click_button "Filter"

    expect(page).to have_text("Beta")
    expect(page).to have_no_text("Alpha")
    expect(page).to have_no_text("Epsilon")
    expect(page).to have_text("Showing 1 of 1")
    expect(page).to have_no_css("[data-test-pagination]")
  end
end
