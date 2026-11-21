# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Root to", type: :system do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password") }

  it "uses the default root, the Dashboard" do
    visit new_admin_user_session_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    expect(page).to have_current_path(admin_root_path)
  end

  it "sets the root to \"stores#index\"" do
    register_resources do
      set_application_setting(:root_to, 'stores#index')
    end
    visit new_admin_user_session_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    expect(page).to have_page_title("Bookstores")
  end
end
