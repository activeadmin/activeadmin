# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index download formats", type: :request do
  def register_post_index(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  def download_links
    %w(CSV XML JSON PDF).select { |format| response_html.has_link?(format, exact: true) }
  end

  before { Post.create!(title: "Hello World") }

  it "links to CSV, XML and JSON by default" do
    register_post_index

    get admin_posts_path

    expect(response_html).to have_download_link("CSV")
    expect(response_html).to have_download_link("XML")
    expect(response_html).to have_download_link("JSON")
    expect(download_links).to eq %w(CSV XML JSON)
  end

  it "shows no links when download_links is false" do
    register_post_index { index download_links: false }

    get admin_posts_path

    expect(response_html).to have_css("[data-test-page-content]")
    expect(download_links).to be_empty
  end

  it "shows only the formats given" do
    register_post_index { index download_links: [:pdf] }

    get admin_posts_path

    expect(response_html).to have_download_link("PDF")
    expect(download_links).to eq %w(PDF)
  end

  it "shows only the formats a proc returns" do
    register_post_index { index download_links: -> { [:csv] } }

    get admin_posts_path

    expect(response_html).to have_download_link("CSV")
    expect(download_links).to eq %w(CSV)
  end

  context "when a proc returns false" do
    before { register_post_index { index download_links: proc { false } } }

    it "shows no links" do
      get admin_posts_path

      expect(response_html).to have_css("[data-test-page-content]")
      expect(download_links).to be_empty
    end

    %w(csv xml json).each do |format|
      it "denies #{format} requests" do
        get admin_posts_path(format: format)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(I18n.t("active_admin.access_denied.message"))
      end
    end
  end

  context "when a proc returns only json" do
    before { register_post_index { index download_links: -> { [:json] } } }

    %w(csv xml).each do |format|
      it "denies #{format} requests" do
        get admin_posts_path(format: format)

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(I18n.t("active_admin.access_denied.message"))
      end
    end

    it "allows json requests" do
      get admin_posts_path(format: :json)

      expect(response).to have_http_status(:ok)
    end
  end
end
