# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Namespace root", type: :request do
  # Fixes failure with: bin/rspec spec/requests --seed 34371
  around do |example|
    with_resources_during(example) {}
  end

  it "renders the dashboard by default" do
    with_root_to("dashboard#index") do
      get admin_root_path
    end

    expect(response).to have_http_status(:ok)
    expect(page_header_text).to eq("Dashboard")
  end

  it "can route the namespace root to a resource index" do
    with_root_to("stores#index") do
      get admin_root_path
    end

    expect(response).to have_http_status(:ok)
    expect(page_header_text).to eq("Bookstores")
  end

  def with_root_to(root_to)
    previous_root_to = ActiveAdmin.application.root_to
    ActiveAdmin.application.root_to = root_to
    reload_routes!
    yield
  ensure
    ActiveAdmin.application.root_to = previous_root_to
  end

  def page_header_text
    Nokogiri::HTML(response.body).at_css("[data-test-page-header] h2")&.text.to_s.squish
  end
end
