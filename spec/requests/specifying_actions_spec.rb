# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Specifying actions", type: :request do
  it "returns 404 for show when only index is enabled" do
    register_resources do
      ActiveAdmin.register Post do
        actions :index
        index do
          column do |post|
            link_to "View", "/admin/posts/#{post.id}"
          end
        end
      end
    end
    Post.create!(title: "Hello World", starred: nil)
    get admin_posts_path

    expect(response_html).to have_link("View", exact: true)
    get response_html.find_link("View", exact: true)[:href]

    expect(response).to have_http_status(:not_found)
  end
end
