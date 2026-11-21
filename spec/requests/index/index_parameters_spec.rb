# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index download_links settings", type: :request do
  before { Post.create!(title: "Hello World") }

  it "hides download links when the index disables them" do
    30.times { |i| Post.create!(title: "Post #{i}") }
    register_resources do
      ActiveAdmin.register(Post) { index as: :table, download_links: false }
    end

    get admin_posts_path

    expect(response_html).to have_css("[data-test-page-content]")
    expect(response_html).to have_no_link("CSV")
  end

  context "when disabled for the whole application" do
    around do |example|
      original = ActiveAdmin.application.download_links
      ActiveAdmin.application.download_links = false
      example.run
    ensure
      ActiveAdmin.application.download_links = original
    end

    it "hides download links" do
      register_resources { ActiveAdmin.register(Post) { index as: :table } }

      get admin_posts_path

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_css("[data-test-page-content]")
      expect(response_html).to have_no_link("CSV")
    end
  end

  context "when disabled for one namespace" do
    after do
      # Namespaces outlive resource reloading, so remove this one before the
      # routes are reloaded after the example.
      ActiveAdmin.application.namespaces.instance_variable_get(:@namespaces).delete(:superadmin)
    end

    def register_post_in_both_namespaces(&superadmin_index)
      register_resources do
        ActiveAdmin.application.namespace(:superadmin).download_links = false
        ActiveAdmin.register AdminUser, namespace: :superadmin
        ActiveAdmin.register(Post) { index as: :table }
        ActiveAdmin.register(Post, namespace: :superadmin, &superadmin_index)
      end
    end

    it "hides them in that namespace only" do
      register_post_in_both_namespaces { index as: :table }

      get superadmin_posts_path

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_css("[data-test-page-content]")
      expect(response_html).to have_no_link("CSV")

      get admin_posts_path

      expect(response_html).to have_download_link("CSV")
    end

    it "shows them for a resource that enables them" do
      register_post_in_both_namespaces { index as: :table, download_links: true }

      get superadmin_posts_path

      expect(response).to have_http_status(:ok)
      expect(response_html).to have_download_link("CSV")
    end
  end
end
