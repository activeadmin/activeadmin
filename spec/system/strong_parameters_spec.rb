# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Strong parameters", type: :system do
  let!(:category) { Category.create!(name: "Music") }
  let(:author) { User.create!(first_name: "John", last_name: "Doe", username: "johndoe") }
  let!(:post) { Post.create!(title: "Hello World", author: author, starred: nil) }

  around do |example|
    original = ActionController::Parameters.action_on_unpermitted_parameters
    ActionController::Parameters.action_on_unpermitted_parameters = false
    example.run
  ensure
    ActionController::Parameters.action_on_unpermitted_parameters = original
  end

  before do
    login_as_admin
  end

  it "updates permitted parameters from a list" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :author, :title, :starred
      end
    end

    visit admin_posts_path
    click_link "Edit", exact: true
    fill_in "Title", with: "Hello World from update"
    check "Starred"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
    expect(page).to have_attributes_table_text("Starred", "Yes")
    expect(post.reload.starred).to be(true)
  end

  it "updates permitted parameters from a block" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params do
          allow = [:author, :title]
          allow << :starred
          allow
        end
      end
    end

    visit admin_posts_path
    click_link "Edit", exact: true
    fill_in "Title", with: "Hello World from update"
    check "Starred"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
    expect(page).to have_attributes_table_text("Starred", "Yes")
    expect(post.reload.starred).to be(true)
  end

  it "keeps unpermitted parameters unchanged" do
    register_resources do
      ActiveAdmin.register Post do
        permit_params :author, :title
      end
    end

    visit admin_posts_path
    click_link "Edit", exact: true
    fill_in "Title", with: "Hello World from update"
    check "Starred"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(page).to have_attributes_table_text("Title", "Hello World from update")
    expect(page).to have_attributes_table_text("Author", "John Doe")
    expect(page).to have_attributes_table_text("Starred", "Unknown")
    expect(post.reload.starred).to be_nil
  end
end
