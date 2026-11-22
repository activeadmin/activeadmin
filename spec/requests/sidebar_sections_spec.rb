# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Sidebar sections", type: :request do
  let!(:post) { Post.create!(title: "Hello World") }

  before do
    enable_authentication
    login_as_admin
  end

  def help_sidebar
    Capybara.string(response.body).find_by_id("help_sidebar_section")
  end

  context "without a block or partial name" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) { sidebar :help }
      end
    end

    it "renders the partial named after the sidebar" do
      write_view "admin/posts/_help_sidebar.html.erb", "<p>Hello World from a partial</p>"

      get admin_posts_path

      expect(help_sidebar).to have_text("Hello World from a partial")
    end
  end

  context "with a partial name" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) { sidebar :help, partial: "custom_help_partial" }
      end
    end

    it "renders that partial" do
      write_view "admin/posts/_custom_help_partial.html.erb", "<p>Hello World from a custom partial</p>"

      get admin_posts_path

      expect(help_sidebar).to have_text("Hello World from a custom partial")
    end
  end

  it "renders a sidebar for all actions" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get edit_admin_post_path(post)

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar for only one action" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help, only: :index do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get edit_admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar for all except one action" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help, except: :index do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get edit_admin_post_path(post)

    expect(response_html).to have_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar for only one action with if clause that returns false" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help, only: :index, if: proc { current_active_admin_user.nil? } do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get edit_admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar for only one action with if clause with method symbol" do
    register_resources do
      stub_const(
        "SidebarHelper", Module.new do
        def can_sidebar?
          false
        end
      end)
      ActiveAdmin.register Post do
        controller { helper SidebarHelper }
        sidebar :help, only: :index, if: :can_sidebar? do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get edit_admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar for only one action with if clause that returns true" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help, only: :show, if: proc { !current_active_admin_user.nil? } do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_post_path(post)

    expect(response_html).to have_css("#help_sidebar_section", text: "Need help")

    get edit_admin_post_path(post)

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")

    get admin_posts_path
    get new_admin_post_path

    expect(response_html).to have_no_text("Need help? Email us at help@example.com")
  end

  it "renders a sidebar with deep content" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help do
          ul do
            li "First List First Item"
            li "First List Second Item"
          end
          ul do
            li "Second List First Item"
            li "Second List Second Item"
          end
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_css("#help_sidebar_section", text: "First List First Item")
    expect(response_html).to have_css("#help_sidebar_section", text: "Second List Second Item")
  end

  it "places the sidebar at the top using priority option" do
    register_resources do
      ActiveAdmin.register Post do
        sidebar :help, priority: 0 do
          "Need help? Email us at help@example.com"
        end
      end
    end

    get admin_posts_path

    expect(help_sidebar).to have_text("Need help? Email us at help@example.com")
    expect(response_html).to have_css("#help_sidebar_section ~ #filters_sidebar_section")
  end
end
