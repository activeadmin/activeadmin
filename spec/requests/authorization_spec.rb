# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Authorization", type: :request do
  let!(:post_record) { Post.create!(title: "Hello World") }
  let(:denied_message) { I18n.t("active_admin.access_denied.message") }

  before do
    enable_authentication
    login_as_admin
  end

  def register_resources_for(adapter)
    set_namespace_setting(:admin, :authorization_adapter, adapter)
    register_resources do
      ActiveAdmin.register Post
      ActiveAdmin.register_page "No Access"
    end
  end

  # The flash markup has no class or data attribute to select it by, so
  # this checks the flash itself and then that the page shows its message.
  def expect_access_denied
    expect(response).to redirect_to(admin_posts_path)
    expect(flash[:error]).to eq denied_message

    follow_redirect!

    expect(response_html).to have_text(denied_message)
  end

  shared_examples "an authorization adapter" do
    it "denies a resource action and sends the user back" do
      get edit_admin_post_path(post_record), headers: { "HTTP_REFERER" => admin_posts_path }

      expect_access_denied
    end

    it "hides action items for denied actions" do
      get admin_post_path(post_record)

      expect(response_html).to have_page_title("Hello World")
      expect(response_html).to have_no_css("[data-test-action-items] a", text: "Edit")
    end

    it "denies a page" do
      get admin_no_access_path, headers: { "HTTP_REFERER" => admin_posts_path }

      expect_access_denied
    end

    it "allows a permitted page" do
      get admin_dashboard_path

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_page_title("Dashboard")
    end
  end

  context "with a custom adapter" do
    before do
      adapter = Class.new(ActiveAdmin::AuthorizationAdapter) do
        def authorized?(action, subject = nil)
          case subject
          when normalized(Post)
            ![:edit, :update, :destroy].include?(action)
          when ActiveAdmin::Page
            subject.name != "No Access"
          else
            false
          end
        end
      end

      register_resources_for(adapter)
    end

    it_behaves_like "an authorization adapter"
  end

  context "with CanCan" do
    before do
      ability = Class.new do
        include CanCan::Ability

        def initialize(user)
          can [:edit, :destroy], Post, author_id: user.id
          can :read, Post

          can :read, ActiveAdmin::Page, name: "Dashboard"
          cannot :read, ActiveAdmin::Page, name: "No Access"
        end
      end
      # The CanCan adapter looks up the ability class by name.
      stub_const("Ability", ability)

      register_resources_for(ActiveAdmin::CanCanAdapter)
    end

    it_behaves_like "an authorization adapter"
  end

  context "with Pundit" do
    # Uses the policies in the test app (spec/support/templates/policies).
    before { register_resources_for(ActiveAdmin::PunditAdapter) }

    it_behaves_like "an authorization adapter"

    it "shows only the current user's comments" do
      commenter = AdminUser.create!(email: "commenter@example.com", password: "password", password_confirmation: "password")
      admin = AdminUser.find_by!(email: "admin@example.com")
      { commenter => 5, admin => 3 }.each do |author, count|
        count.times do |i|
          ActiveAdmin::Comment.create!(namespace: "admin", body: "Comment #{i}", resource: post_record, author: author)
        end
      end

      get admin_dashboard_path

      expect(response_html).to have_css("#main-menu li a", exact_text: "Comments")

      get admin_comments_path

      expect(response_html).to have_table_rows(3)

      get admin_post_path(post_record)

      expect(response_html).to have_css("[data-test-comment-container]", count: 3)
      expect(response_html).to have_button("Add Comment")
    end
  end
end
