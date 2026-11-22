# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index filters", type: :request do
  it "removes a default filter through the resource DSL" do
    register_resources do
      ActiveAdmin.register(Post) { remove_filter :title }
    end

    get admin_posts_path

    expect(response_html).to have_css("#filters_sidebar_section")
    expect(response_html).to have_field("Body")
    expect(response_html).to have_no_field("Title")
  end

  it "keeps default filters when adding a custom filter" do
    register_resources do
      ActiveAdmin.register Post do
        preserve_default_filters!
        filter :title, label: "Post title"
      end
    end

    get admin_posts_path

    expect(response_html).to have_field("Post title")
    expect(response_html).to have_field("Body")
  end

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
