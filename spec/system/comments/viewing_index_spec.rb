# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Comments index", type: :system do
  it "renders all comments for a namespace" do
    author = User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe")
    Post.create!(title: "Hello World", author: author, starred: nil)
    register_resources do
      ActiveAdmin.register Post
    end

    login_as_admin
    visit admin_post_path(Post.first)
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"
    visit admin_comments_path

    expect(page).to have_table_header("Body")
    expect(page).to have_table_header("Resource")
    expect(page).to have_table_header("Author")
    expect(page).to have_text("Hello from Comment")
    expect(page).to have_link("Hello World", exact: true)
    expect(page).to have_text("admin@example.com")
    expect(page).to have_no_css("[data-test-action-items] a", exact_text: "New Comment")
  end
end
