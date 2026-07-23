# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Custom Namespace Routes", type: :request do
  # Test that custom namespaces (other than :admin) can access route helpers
  # This reproduces the bug from: activeadmin-v4-custom-namespace-bug-report.md

  describe "with :active_admin namespace" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { application.namespace(:active_admin) }

    around do |example|
      original_application = ActiveAdmin.application
      ActiveAdmin.application = application
      application.default_namespace = :active_admin

      load_resources do
        ActiveAdmin.register(Post, namespace: :active_admin)
      end

      example.call
    ensure
      ActiveAdmin.application = original_application
    end

    after do
      application.namespaces.instance_variable_get(:@namespaces).delete(:active_admin)
    end

    it "should generate route helpers for the custom namespace" do
      # These route helpers should exist and be callable
      expect(active_admin_posts_path).to eq "/active_admin/posts"
      expect(new_active_admin_post_path).to eq "/active_admin/posts/new"
      expect(edit_active_admin_post_path(1)).to eq "/active_admin/posts/1/edit"
      expect(active_admin_post_path(1)).to eq "/active_admin/posts/1"
    end

    it "should be able to access route helpers via Helpers::Routes" do
      # This is how ActiveAdmin internally accesses route helpers
      expect(ActiveAdmin::Helpers::Routes).to respond_to(:active_admin_posts_path)
      expect(ActiveAdmin::Helpers::Routes.active_admin_posts_path).to eq "/active_admin/posts"
    end

    it "should generate routes accessible from controllers" do
      get "/active_admin/posts"
      expect(response).to have_http_status(:success)
    end

    it "should render index page with sortable columns" do
      # This tests that the view can generate URLs for sortable columns
      Post.create!(title: "Test Post", body: "Test body")

      get "/active_admin/posts"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Test Post")

      # The page should contain links for sorting (which use route helpers internally)
      # Note: We're testing that it doesn't raise ActionController::UrlGenerationError
    end
  end

  describe "with :custom_admin namespace" do
    let(:application) { ActiveAdmin::Application.new }

    around do |example|
      original_application = ActiveAdmin.application
      ActiveAdmin.application = application
      application.default_namespace = :custom_admin

      load_resources do
        ActiveAdmin.register(Post, namespace: :custom_admin)
      end

      example.call
    ensure
      ActiveAdmin.application = original_application
    end

    after do
      application.namespaces.instance_variable_get(:@namespaces).delete(:custom_admin)
    end

    it "should generate route helpers for the custom namespace" do
      expect(custom_admin_posts_path).to eq "/custom_admin/posts"
      expect(new_custom_admin_post_path).to eq "/custom_admin/posts/new"
    end

    it "should be accessible from Helpers::Routes" do
      expect(ActiveAdmin::Helpers::Routes).to respond_to(:custom_admin_posts_path)
      expect(ActiveAdmin::Helpers::Routes.custom_admin_posts_path).to eq "/custom_admin/posts"
    end
  end

  describe "with namespace containing underscores" do
    let(:application) { ActiveAdmin::Application.new }

    around do |example|
      original_application = ActiveAdmin.application
      ActiveAdmin.application = application
      application.default_namespace = :super_admin

      load_resources do
        ActiveAdmin.register(Category, namespace: :super_admin)
      end

      example.call
    ensure
      ActiveAdmin.application = original_application
    end

    after do
      application.namespaces.instance_variable_get(:@namespaces).delete(:super_admin)
    end

    it "should generate route helpers for namespace with underscores" do
      expect(super_admin_categories_path).to eq "/super_admin/categories"
      expect(new_super_admin_category_path).to eq "/super_admin/categories/new"
    end

    it "should be accessible from Helpers::Routes" do
      expect(ActiveAdmin::Helpers::Routes).to respond_to(:super_admin_categories_path)
      expect(ActiveAdmin::Helpers::Routes.super_admin_categories_path).to eq "/super_admin/categories"
    end
  end
end
