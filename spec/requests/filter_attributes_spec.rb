# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Filter attributes", type: :request do
  before do
    register_resources do
      ActiveAdmin.register User
    end
    User.create!(first_name: "John", last_name: "Doe", username: "johndoe")
    get admin_users_path
  end

  it "default index page" do
    expect(response_html).to have_no_text("Encrypted")
    expect(response_html).to have_text("Age")
  end

  it "default new form" do
    get response_html.find_link("New User", exact: true)[:href]

    expect(response_html).to have_no_text("Encrypted")
    expect(response_html).to have_text("Age")
  end

  it "default edit form" do
    get response_html.find_link("Edit", exact: true)[:href]

    expect(response_html).to have_no_text("Encrypted")
    expect(response_html).to have_text("Age")
  end

  it "default show page" do
    get response_html.find_link("View", exact: true)[:href]

    expect(response_html).to have_no_text("Encrypted")
    expect(response_html).to have_text("Age")
  end

  it "default CSV export" do
    get response_html.find_link("CSV", exact: true)[:href]

    expect(response_html).to have_no_text("Encrypted")
    expect(response_html).to have_text("Age")
  end

  it "default XML" do
    get response_html.find_link("XML", exact: true)[:href]

    expect(response).to have_http_status(:ok)
    expect(response.media_type).to eq("application/xml")
    expect(response.body).to include("<users type=\"array\">")
    expect(response.body).not_to include("encrypted")
  end
end
