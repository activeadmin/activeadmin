# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Registering resources", type: :system do
  before do
    login_as_admin
    Post.create!(title: "Hello World", starred: nil)
  end

  it "registers a resource with the defaults" do
    register_resources do
      ActiveAdmin.register Post
    end

    visit admin_root_path

    expect(page).to have_text("Posts")

    click_link "Posts", exact: true

    expect(page).to have_text("Hello World")

    click_link "View", exact: true

    expect(page).to have_text("Hello World")
    expect(page).to have_current_path(%r{\A/admin/posts/\d+\z})
  end

  it "registers a resource with another name" do
    register_resources do
      ActiveAdmin.register Post, as: "My Post"
    end

    visit admin_root_path

    expect(page).to have_text("My Posts")

    click_link "My Posts", exact: true

    expect(page).to have_text("Hello World")

    click_link "View", exact: true

    expect(page).to have_text("Hello World")
    expect(page).to have_current_path(%r{\A/admin/my_posts/\d+\z})
  end
end
