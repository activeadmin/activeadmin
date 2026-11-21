# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Sidebar sections", type: :request do
  before { Post.create!(title: "Hello World") }

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
end
