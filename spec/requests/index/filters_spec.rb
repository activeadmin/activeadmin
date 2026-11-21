# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index filters", type: :request do
  it "omits the filter sidebar when filters are disabled" do
    register_resources do
      ActiveAdmin.register(Post) { config.filters = false }
    end

    get admin_posts_path

    expect(response).to have_http_status(:ok)
    expect(response_html).to have_page_title("Posts")
    expect(response_html).to have_no_css("#filters_sidebar_section")
    expect(response_html).to have_no_text("Filters")
  end
end
