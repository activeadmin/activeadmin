# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Belongs to", type: :system do
  let(:john) { User.create!(first_name: "John", last_name: "Doe", username: "johndoe") }
  let(:jane) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let!(:john_post) { Post.create!(title: "Hello World", author: john) }
  let!(:jane_post) { Post.create!(title: "Hello World", author: jane) }

  before { login_as_admin }

  it "updates a child resource page" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        permit_params :title, :body, :published_date

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    end

    visit admin_user_post_path(jane, jane_post)
    click_link "Edit Post", exact: true

    expect(page).to have_css("form[action='/admin/users/#{jane.id}/posts/#{jane_post.id}']")
    expect(page).to have_breadcrumb_link("Hello World")

    fill_in "Title", with: "Jane's updated post"
    fill_in "Body", with: "Updated body"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(jane_post.reload).to have_attributes(title: "Jane's updated post", body: "Updated body", author_id: jane.id)
    expect(john_post.reload.title).to eq("Hello World")
  end

  it "updates a child resource page with custom configuration" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :author, class_name: "User", param: "user_id", route_name: "user"
        permit_params :title

        form do |f|
          f.inputs { f.input :title }
          f.actions
        end
      end
    end

    visit admin_user_post_path(jane, jane_post)
    click_link "Edit Post", exact: true

    expect(page).to have_css("form[action='/admin/users/#{jane.id}/posts/#{jane_post.id}']")
    expect(page).to have_breadcrumb_link("Hello World")

    fill_in "Title", with: "Jane's custom post"
    click_button "Update Post"

    expect(page).to have_text("Post was successfully updated.")
    expect(jane_post.reload).to have_attributes(title: "Jane's custom post", author_id: jane.id)
    expect(john_post.reload.title).to eq("Hello World")
  end

  it "creates a child resource page" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        permit_params :title, :body, :published_date

        form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_date
          end
          f.actions
        end
      end
    end

    visit admin_user_posts_path(jane)
    click_link "New Post", exact: true

    expect(page).to have_css("form[action='/admin/users/#{jane.id}/posts']")

    fill_in "Title", with: "Hello World"
    fill_in "Body", with: "This is the body"
    click_button "Create Post"

    expect(page).to have_text("Post was successfully created.")
    expect(page).to have_attributes_table_text("Title", "Hello World")
    expect(page).to have_attributes_table_text("Body", "This is the body")
    expect(page).to have_attributes_table_text("Author", "Jane Doe")
  end

  it "creates a child resource page when belongs to defined after permitted params" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        permit_params :title, :body, :published_date
        belongs_to :user

        form do |f|
          f.inputs do
            f.input :title
            f.input :body
          end
          f.actions
        end
      end
    end

    visit admin_user_posts_path(jane)
    click_link "New Post", exact: true

    expect(page).to have_css("form[action='/admin/users/#{jane.id}/posts']")

    fill_in "Title", with: "Post with early permitted params"
    fill_in "Body", with: "Permitted body"

    expect { click_button "Create Post" }.to change(Post, :count).by(1)

    expect(page).to have_text("Post was successfully created.")
    created_post = Post.find_by!(title: "Post with early permitted params")
    expect(created_post).to have_attributes(body: "Permitted body", author_id: jane.id)
  end

  it "renders a child resource page" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
      end
    end

    visit admin_user_posts_path(jane)
    click_link "View", exact: true

    expect(page).to have_current_path(admin_user_post_path(jane, jane_post))
    expect(page).to have_css("#main-menu li[data-item-id=\"users\"] a.selected", exact_text: "Users")
  end

  it "when the belongs to is optional" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user, optional: true
      end
    end

    visit admin_user_posts_path(jane)

    expect(page).to have_css("#main-menu li[data-item-id=\"users\"] a.selected", exact_text: "Users")
    expect(page).to have_css("#main-menu a", exact_text: "Posts")

    click_link "Posts", exact: true

    expect(page).to have_css("#main-menu li[data-item-id=\"posts\"] a.selected", exact_text: "Posts")
  end

  it "shows belongs to resources in main menu" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register Post do
        belongs_to :user
        navigation_menu :user
      end
    end

    visit admin_user_posts_path(jane)
    click_link "View", exact: true

    expect(page).to have_css("#main-menu li[data-item-id=\"posts\"] a.selected", exact_text: "Posts")
  end
end
