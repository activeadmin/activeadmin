# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index navigation", type: :system, js: true do
  before { login_as_admin }

  it "keeps the filter and scope when changing page size, sorting and moving to another page" do
    %w[A B C D E F].each do |suffix|
      Post.create!(title: "Target #{suffix}", published_date: Time.current)
    end
    Post.create!(title: "Target G")
    Post.create!(title: "Other", published_date: Time.current)
    register_resources do
      ActiveAdmin.register Post do
        config.per_page = [2, 4]
        config.sort_order = "title_asc"
        scope :all, default: true
        scope(:published) { |posts| posts.where.not(published_date: nil) }
        filter :title
        index { column :title }
      end
    end

    visit admin_posts_path(scope: "published", q: { title_cont: "Target" })

    expect(page).to have_table_rows(2)

    find("select.pagination-per-page").select("4")

    expect(page).to have_text("Showing 1-4 of 6")
    expect(table_rows(page, "#index_table_posts").drop(1)).to eq [
      ["Target A"], ["Target B"], ["Target C"], ["Target D"]
    ]

    find("th[data-sortable] a", text: /\Atitle\z/i).click

    expect(page).to have_css("#index_table_posts tbody tr:first-child td", exact_text: "Target F")

    expect(table_rows(page, "#index_table_posts").drop(1)).to eq [
      ["Target F"], ["Target E"], ["Target D"], ["Target C"]
    ]

    within("[data-test-pagination]") { click_link "2", exact: true }

    expect(page).to have_text("Showing 5-6 of 6")
    expect(table_rows(page, "#index_table_posts").drop(1)).to eq [
      ["Target B"], ["Target A"]
    ]
    expect(page).to have_scope("Published", selected: true)
    expect(page).to have_field("Title", with: "Target")
    expect(page).to have_select(nil, class: "pagination-per-page", selected: "4")
    params = Rack::Utils.parse_nested_query(URI(page.current_url).query)
    expect(params).to include("scope" => "published", "q" => { "title_cont" => "Target" }, "per_page" => "4", "order" => "title_desc")
  end
end
