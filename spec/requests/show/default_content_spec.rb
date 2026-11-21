# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Show page default content", type: :request do
  let(:author) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let(:category) { Category.create!(name: "Stories") }
  let!(:post) { Post.create!(title: "Hello World", author: author, category: category, starred: false) }

  it "renders the default attributes and action items" do
    register_resources do
      ActiveAdmin.register Post
    end

    get admin_post_path(post)

    expect(response_html).to have_attributes_table_text("Title", "Hello World")
    expect(response_html).to have_attributes_table_text("Body", "Empty")
    expect(response_html).to have_css(".attributes-table th", exact_text: "Created At")
    expect(response_html.find(".attributes-table th", exact_text: "Created At").find(:xpath, "following-sibling::td").text).to match(/\w+ \d{1,2}, \d{4} \d{2}:\d{2}/)
    expect(response_html).to have_attributes_table_text("Author", "Jane Doe")
    expect(response_html).to have_attributes_table_text("Starred", "No")
    expect(response_html).to have_css("[data-test-action-items] a", exact_text: "Delete Post")
    expect(response_html).to have_css("[data-test-action-items] a", exact_text: "Edit Post")
  end

  it "links attributes to registered resources" do
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register User
    end

    get admin_post_path(post)

    expect(response_html).to have_attributes_table_text("Author", "Jane Doe")
    author_cell = response_html.find(".attributes-table th", exact_text: "Author").find(:xpath, "following-sibling::td")
    expect(author_cell).to have_link("Jane Doe", href: admin_user_path(author), exact: true)
  end

  it "renders a chosen set of attributes" do
    register_resources do
      ActiveAdmin.register Post do
        show do
          attributes_table_for(resource, :title, :body, :created_at, :updated_at)
        end
      end
    end

    get admin_post_path(post)

    expect(response_html).to have_attributes_table_text("Title", "Hello World")
    expect(response_html).to have_attributes_table_text("Body", "Empty")
    expect(response_html).to have_css(".attributes-table th", exact_text: "Created At")
    expect(response_html.find(".attributes-table th", exact_text: "Created At").find(:xpath, "following-sibling::td").text).to match(/\w+ \d{1,2}, \d{4} \d{2}:\d{2}/)
    expect(response_html).to have_no_css(".attributes-table th", exact_text: "Author")
  end

  it "shows columns with counter cache-like names" do
    register_resources do
      ActiveAdmin.register User
    end

    get admin_user_path(author)

    expect(response_html).to have_attributes_table_text("First Name", "Jane")
    expect(response_html).to have_attributes_table_text("Last Name", "Doe")
    expect(response_html).to have_attributes_table_text("Sign In Count", "0")
  end

  it "hides counter cache columns" do
    register_resources do
      ActiveAdmin.register Category
    end

    get admin_category_path(category)

    expect(response_html).to have_attributes_table_text("Name", "Stories")
    expect(response_html).to have_no_css(".attributes-table th", exact_text: "Posts Count")
  end
end
