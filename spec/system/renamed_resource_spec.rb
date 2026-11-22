# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Renamed resource", type: :system do
  before do
    Category.create!(name: "Music")
    User.create!(first_name: "John", last_name: "Doe", username: "johndoe")
    login_as_admin
  end

  it "submits the default form" do
    register_resources do
      ActiveAdmin.register Blog::Post, as: 'Post' do
        permit_params :custom_category_id, :author_id, :title,
                      :body, :position, :published_date, :starred
      end
    end

    visit admin_posts_path
    click_link "New Post", exact: true
    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    select "Music", from: "Category"
    select "John Doe", from: "Author"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
    expect(page).to have_attributes_table_text("Category", "Music")
    expect(page).to have_attributes_table_text("Author", "John Doe")
  end

  it "with a belongs_to optional association" do
    register_resources do
      ActiveAdmin.register User, as: 'Author' do
        show do |author|
          attributes_table_for(resource) do
            row :articles do
              link_to 'Author Articles', admin_author_articles_path(author)
            end
          end
        end
      end

      ActiveAdmin.register Post, as: 'Article' do
        belongs_to :author, optional: true
        permit_params :custom_category_id, :author_id, :title,
                      :body, :position, :published_date, :starred
      end

      ActiveAdmin.register Post, as: 'News', namespace: :admin2
    end

    visit admin_articles_path
    click_link "New Article", exact: true
    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    select "Music", from: "Category"
    select "John Doe", from: "Author"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
    expect(page).to have_attributes_table_text("Category", "Music")
    expect(page).to have_attributes_table_text("Author", "John Doe")

    click_link "John Doe", exact: true
    click_link "Author Articles", exact: true

    expect(page).to have_table_header("Title")
    expect(page).to have_table_header("Body")
    expect(page).to have_text("Hello World")
    expect(page).to have_text("This is the body")
  end
end
