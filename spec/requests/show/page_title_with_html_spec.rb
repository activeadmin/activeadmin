# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Show page title with HTML", type: :request do
  let(:author) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let(:post) { Post.create!(title: "<a href='https://somewhere-nasty.com/'>John Doe</a>", author: author) }

  it "escapes an HTML string as the title" do
    register_resources do
      ActiveAdmin.register Post
    end

    get admin_post_path(post)

    expect(response).to have_http_status(:ok)
    expect(response_html.find("[data-test-page-header] h2")).to have_no_css("a")
    expect(response_html).to have_page_title("<a href='https://somewhere-nasty.com/'>John Doe</a>")
  end
end
