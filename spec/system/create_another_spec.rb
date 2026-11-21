# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Create another", type: :system do
  before do
    login_as_admin
  end

  it "creates another record when selected, then returns to the saved record" do
    register_resources do
      ActiveAdmin.register Post do
        config.create_another = true

        permit_params :custom_category_id, :author_id, :title,
                      :body, :position, :published_date, :starred
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true
    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    expect(page).to have_unchecked_field("Create another Post")
    check "Create another"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_text("New Post")
    expect(page).to have_checked_field("Create another")

    fill_in "Title", with: "Another Hello World"
    fill_in "Body", with: "This is the another body"
    uncheck "Create another"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Another Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the another body")
  end
end
