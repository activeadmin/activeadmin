# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Belongs to", type: :request do
  let(:john) { User.create!(first_name: "John", last_name: "Doe", username: "johndoe") }
  let(:jane) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let!(:john_post) { Post.create!(title: "Hello World", author: john) }
  let!(:jane_post) { Post.create!(title: "Hello World", author: jane) }

  it "renders the child resource index page" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    end

    get admin_user_posts_path(jane)

    expect(response_html).to have_css("#main-menu li[data-item-id=\"users\"] a.selected", exact_text: "Users")
    expect(response_html).to have_no_css("#main-menu a", exact_text: "Posts")
    expect(response_html).to have_text("Showing 1 of 1")
    expect(response_html).to have_breadcrumb_link("Users", href: admin_users_path)
    expect(response_html).to have_breadcrumb_link("Jane Doe", href: admin_user_path(jane))
  end

  it "renders the child resource index page when the resource has an `as:` alias" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post, as: "Story" do
        belongs_to :user, optional: true
      end
    end

    get admin_user_stories_path(jane)

    expect(response_html).to have_text("Showing 1 of 1")
    expect(response_html).to have_breadcrumb_link("Users", href: admin_users_path)
    expect(response_html).to have_breadcrumb_link("Jane Doe", href: admin_user_path(jane))
  end

  it "renders the child resource index page with a custom collection_name" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user, optional: true
        controller do
          defaults collection_name: :unstarred_posts
        end
      end
    end
    Post.create!(title: "In the collection", author: jane, starred: false)
    Post.create!(title: "Outside it", author: jane, starred: nil)
    get admin_user_posts_path(jane)

    expect(response_html).to have_text("In the collection")
    expect(response_html).to have_no_text("Outside it")
  end
end
