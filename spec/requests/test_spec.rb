# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Test", type: :request do
  let(:admin_user) do
    AdminUser.create_with(password: "password", password_confirmation: "password").find_or_create_by!(email: "test@test.com")
  end

  around do |example|
    ActiveAdmin.application.authentication_method = :authenticate_admin_user!
    ActiveAdmin.application.current_user_method = :current_admin_user
    with_resources_during(example) {}
    ActiveAdmin.application.authentication_method = false
    ActiveAdmin.application.current_user_method = false
  end

  it "test" do
    sign_in admin_user
    get admin_dashboard_path
    expect(response.successful?).to eq true
    expect(response.body).to include("Dashboard")
    expect(response.body).to include("Welcome to Active Admin. This is the default dashboard page.")
  end

  it "redirects to login page when not logged in" do
    sign_out admin_user
    get admin_dashboard_path
    expect(response).to redirect_to new_admin_user_session_path
  end

  describe "" do
    before do
      ActiveAdmin.application.footer = "MyApp Revision 123"
    end

    it "" do
      sign_in admin_user
      get admin_dashboard_path
      expect(response.body).to include("MyApp Revision 123")
    end
  end

  describe "" do
    before do
      ActiveAdmin.application.footer = proc { "Enjoy MyApp Revision 123, #{controller.current_admin_user.try(:email)}!" }
    end

    it "" do
      sign_in admin_user
      get admin_dashboard_path
      expect(response.body).to include("Enjoy MyApp Revision 123, test@test.com!")
    end
  end
end
