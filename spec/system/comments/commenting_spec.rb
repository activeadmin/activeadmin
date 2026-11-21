# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Comments", type: :system do
  let(:user) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let!(:post) { Post.create!(title: "Hello World", author: user, starred: nil) }

  before do
    login_as_admin
  end

  it "renders a resource with no comments" do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)

    expect(page).to have_text("Comments (0)")
    expect(page).to have_text("No comments yet.")
  end

  it "creates a new comment" do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"

    expect(page).to have_text("Comment was successfully created")
    expect(page).to have_current_path(%r{\A/admin/posts/\d+\z})
    expect(page).to have_text("Comments (1)")
    expect(page).to have_text("Hello from Comment")
    expect(page).to have_css("[data-test-comment-container]", text: "admin@example.com")
  end

  it "renders a resource with comments turned off" do
    register_resources do
      ActiveAdmin.register Post do
        config.comments = false
      end
    end
    visit admin_post_path(post)

    expect(page).to have_page_title("Hello World")
    expect(page).to have_no_css("#active-admin-comments-form")
    expect(page).to have_no_css("[data-test-comment-container]")
    expect(page).to have_no_text("Comments (0)")
  end

  it "renders a resource in a namespace that doesn't have comments" do
    register_resources do
      set_namespace_setting(:new_namespace, :comments, false)
      ActiveAdmin.register Post, namespace: :new_namespace
      ActiveAdmin.register AdminUser, namespace: :new_namespace
    end
    visit new_namespace_posts_path
    click_link "View", exact: true

    expect(page).to have_page_title("Hello World")
    expect(page).to have_no_text("Comments")
  end

  it "enables comments on per-resource basis" do
    register_resources do
      set_namespace_setting(:new_namespace, :comments, false)
      ActiveAdmin.register Post, namespace: :new_namespace do
        config.comments = true
      end
      ActiveAdmin.register AdminUser, namespace: :new_namespace
    end
    visit new_namespace_posts_path
    click_link "View", exact: true

    expect(page).to have_text("Comments")
  end

  it "creates a comment in one namespace does not create it in another" do
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register Post, namespace: :public
      ActiveAdmin.register AdminUser, namespace: :public
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: "Hello world in admin namespace"
    click_button "Add Comment"

    expect(page).to have_text("Hello world in admin namespace")

    visit public_posts_path
    click_link "View", exact: true

    expect(page).to have_no_text("Hello world in admin namespace")
    expect(page).to have_text("Comments (0)")

    fill_in "comment_body", with: "Hello world in public namespace"
    click_button "Add Comment"

    expect(page).to have_text("Hello world in public namespace")

    visit admin_posts_path
    click_link "View", exact: true

    expect(page).to have_no_text("Hello world in public namespace")
    expect(page).to have_text("Comments (1)")
  end

  it "creates a comment on an aliased resource" do
    register_resources do
      ActiveAdmin.register Post, as: "Article"
    end
    visit admin_articles_path
    click_link "View", exact: true
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"

    expect(page).to have_text("Comment was successfully created")
    expect(page).to have_current_path(%r{\A/admin/articles/\d+\z})
  end

  it "rejects an empty comment" do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: ""
    click_button "Add Comment"

    expect(page).to have_text("Comment wasn't saved, text was empty.")
    expect(page).to have_text("Comments (0)")
  end

  it "renders all comments for a namespace" do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"
    visit admin_comments_path

    expect(page).to have_table_header("Body")
    expect(page).to have_text("Hello from Comment")
  end

  it "adds a comment to a STI superclass" do
    register_resources do
      ActiveAdmin.register User
    end
    Publisher.create!(first_name: "Pragmatic", last_name: "Publishers", username: "pragmaticpublishers")
    visit admin_users_path
    within("tr", text: "Pragmatic") { click_link "View", exact: true }
    fill_in "comment_body", with: "Hello World"
    click_button "Add Comment"

    expect(page).to have_text("Comment was successfully created")
    expect(page).to have_current_path(%r{\A/admin/users/\d+\z})

    visit admin_comments_path

    expect(page).to have_css("[data-test-page-content]", text: "User")
    expect(page).to have_text("Hello World")
  end

  it "adds a comment to a STI subclass" do
    register_resources do
      ActiveAdmin.register Publisher
    end
    Publisher.create!(first_name: "Pragmatic", last_name: "Publishers", username: "pragmaticpublishers")
    visit admin_publishers_path
    click_link "View", exact: true
    fill_in "comment_body", with: "Hello World"
    click_button "Add Comment"

    expect(page).to have_text("Comment was successfully created")
    expect(page).to have_current_path(%r{\A/admin/publishers/\d+\z})
    expect(page).to have_text("Hello World")
  end

  it "adds a comment to an aliased resource with an existing non-aliased config" do
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register Post, as: 'Foo'
    end
    visit admin_foos_path
    click_link "View", exact: true
    fill_in "comment_body", with: "Bar"
    click_button "Add Comment"

    expect(page).to have_current_path(%r{\A/admin/foos/\d+\z})
  end

  it "paginates comments" do
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "admin@example.com")
    70.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)

    expect(page).to have_text("Comments (70)")
    expect(page).to have_text("Displaying comments 1–25 of 70 in total")
    expect(page).to have_css("[data-test-comment-container]", count: 25)
    expect(page).to have_css("[data-test-pagination] a", exact_text: "2")
    expect(page).to have_css("[data-test-pagination] a", exact_text: "3")
    expect(page).to have_css("[data-test-pagination] a", exact_text: "Next")

    click_link "2", exact: true

    expect(page).to have_text("Displaying comments 26–50 of 70 in total")
    expect(page).to have_css("[data-test-comment-container]", count: 25)
    expect(page).to have_css("[data-test-pagination] a", exact_text: "Next")

    click_link "Next", exact: true

    expect(page).to have_css("[data-test-comment-container]", count: 20)
    expect(page).to have_text("Displaying comments 51–70 of 70 in total")
    expect(page).to have_no_css("[data-test-pagination] a", exact_text: "Next")
  end

  it "comments through explicit helper from custom controller" do
    register_resources do
      ActiveAdmin.register Post do
        controller do
          def show
            @post = Post.find(params[:id])
            show!
          end
        end

        show do |post|
          active_admin_comments_for(post)
        end
      end
    end
    visit admin_post_path(post)

    expect(page).to have_button("Add Comment")
    fill_in "comment_body", with: "Comment from the custom controller"
    click_button "Add Comment"

    expect(page).to have_text("Comment was successfully created")
    expect(page).to have_text("Comments (1)")
    expect(ActiveAdmin::Comment.last).to have_attributes(resource: post, body: "Comment from the custom controller")
  end

  it "not authorized to list comments" do
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "commenter@example.com")
    5.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "admin@example.com")
    3.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    register_resources do
      stub_const(
        "NoCommentListForASpecificUser", Class.new(ActiveAdmin::AuthorizationAdapter) do
        def authorized?(action, subject = nil)
          if action == :read && subject == ActiveAdmin::Comment
            user.email != "admin@example.com"
          else
            true
          end
        end
      end)

      set_namespace_setting(:admin, :authorization_adapter, NoCommentListForASpecificUser)

      ActiveAdmin.register Post
    end
    visit admin_post_path(post)

    expect(page).to have_page_title("Hello World")
    expect(page).to have_no_text("Comments")
    expect(page).to have_css("[data-test-comment-container]", count: 0)
    expect(page).to have_no_button("Add Comment")
  end

  it "authorized to list and view own comments" do
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "commenter@example.com")
    5.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "admin@example.com")
    3.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    register_resources do
      stub_const(
        "ListCommentsByCurrentUserOnly", Class.new(ActiveAdmin::AuthorizationAdapter) do
        def scope_collection(collection, action = ActiveAdmin::Authorization::READ)
          if collection.is_a?(ActiveRecord::Relation) && collection.klass == ActiveAdmin::Comment
            collection.where(author: user)
          else
            collection
          end
        end
      end)

      set_namespace_setting(:admin, :authorization_adapter, ListCommentsByCurrentUserOnly)

      ActiveAdmin.register Post
    end
    visit admin_post_path(post)

    expect(page).to have_text("Comments (3)")
    expect(page).to have_css("[data-test-comment-container]", count: 3)
    expect(page).to have_css("[data-test-comment-container]", text: "admin@example.com", count: 3)
    expect(page).to have_no_css("[data-test-comment-container]", text: "commenter@example.com")
    expect(page).to have_button("Add Comment")
  end

  it "deletes a comment from its own show page redirects to the comments index", js: true do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"
    visit admin_comments_path
    click_link "View", exact: true
    accept_confirm { click_link "Delete Comment", exact: true }

    expect(page).to have_current_path(admin_comments_path)
    expect(ActiveAdmin::Comment.exists?(resource: post)).to be(false)
  end

  it "deletes a comment from a commentable resource's page returns to that resource", js: true do
    register_resources do
      ActiveAdmin.register Post
    end
    visit admin_post_path(post)
    fill_in "comment_body", with: "Hello from Comment"
    click_button "Add Comment"
    accept_confirm { click_link "Delete Comment", exact: true }

    expect(page).to have_current_path(%r{\A/admin/posts/\d+\z})
    expect(page).to have_text("Comments (0)")
    expect(ActiveAdmin::Comment.exists?(resource: post)).to be(false)
  end

  it "not authorized to create comments" do
    commenter = AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "commenter@example.com")
    5.times do |i|
      ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post, author: commenter)
    end
    register_resources do
      stub_const(
        "NoNewComments", Class.new(ActiveAdmin::AuthorizationAdapter) do
        def authorized?(action, subject = nil)
          if (action == :new || action == :create) && subject == ActiveAdmin::Comment
            false
          else
            true
          end
        end
      end)

      set_namespace_setting(:admin, :authorization_adapter, NoNewComments)

      ActiveAdmin.register Post
    end
    visit admin_post_path(post)

    expect(page).to have_text("Comments (5)")
    expect(page).to have_css("[data-test-comment-container]", count: 5)
    expect(page).to have_no_button("Add Comment")
  end
end
