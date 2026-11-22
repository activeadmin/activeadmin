# frozen_string_literal: true
require "rails_helper"

# The access denied round trip through a browser (with the Referer it
# sends) is in spec/system/authorization_spec.rb.
RSpec.describe "Authorization", type: :request do
  let!(:post_record) { Post.create!(title: "Hello World") }
  let(:denied_message) { I18n.t("active_admin.access_denied.message") }

  before do
    enable_authentication
    login_as_admin
  end

  # The flash markup has no class or data attribute to select it by, so
  # this checks the flash itself and then that the page shows its message.
  def expect_access_denied
    expect(response).to redirect_to(admin_posts_path)
    expect(flash[:error]).to eq denied_message

    follow_redirect!

    expect(response_html).to have_text(denied_message)
  end

  AuthorizationAdapterHelpers::ADAPTERS.each do |adapter|
    context "with the #{adapter} adapter" do
      before { use_authorization_adapter(adapter) }

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
  end

  it "enforces permissions when the adapter is configured by class name" do
    use_authorization_adapter(:cancan)
    set_namespace_setting(:admin, :authorization_adapter, "ActiveAdmin::CanCanAdapter")

    get edit_admin_post_path(post_record), headers: { "HTTP_REFERER" => admin_posts_path }

    expect_access_denied
  end

  context "when the current user can read but cannot write" do
    before do
      adapter = Class.new(ActiveAdmin::AuthorizationAdapter) do
        def authorized?(action, subject = nil)
          action == ActiveAdmin::Auth::READ
        end
      end
      set_namespace_setting(:admin, :authorization_adapter, adapter)
      register_resources { ActiveAdmin.register(Post) { permit_params :title } }
    end

    it "allows reading the record" do
      get admin_post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_page_title(post_record.title)
    end

    it "rejects a direct create request without saving a record" do
      expect do
        post admin_posts_path, params: { post: { title: "Not allowed" } },
                               headers: { "HTTP_REFERER" => admin_posts_path }
      end.not_to change(Post, :count)

      expect_access_denied
    end

    it "rejects a direct update request without changing the record" do
      patch admin_post_path(post_record), params: { post: { title: "Not allowed" } },
                                          headers: { "HTTP_REFERER" => admin_posts_path }

      expect_access_denied
      expect(post_record.reload.title).to eq("Hello World")
    end

    it "rejects a direct delete request without deleting the record" do
      expect do
        delete admin_post_path(post_record), headers: { "HTTP_REFERER" => admin_posts_path }
      end.not_to change(Post, :count)

      expect_access_denied
      expect(Post.exists?(post_record.id)).to be(true)
    end

    it "rejects a forged batch delete request without deleting selected records" do
      expect do
        post batch_action_admin_posts_path,
             params: { batch_action: "destroy", collection_selection: [post_record.id] },
             headers: { "HTTP_REFERER" => admin_posts_path }
      end.not_to change(Post, :count)

      expect_access_denied
      expect(Post.exists?(post_record.id)).to be(true)
    end
  end

  context "with the pundit adapter" do
    before { use_authorization_adapter(:pundit) }

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
      expect(response_html).to have_css("[data-test-comment-container]", text: "admin@example.com", count: 3)
      expect(response_html).to have_no_css("[data-test-comment-container]", text: "commenter@example.com")
      expect(response_html).to have_button("Add Comment")
    end
  end
end
