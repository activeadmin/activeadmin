# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Signing in", type: :system do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password") }

  it "signs in with valid credentials" do
    visit admin_root_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    expect(page).to have_current_path(admin_root_path)
    expect(page).to have_link("Sign out", href: destroy_admin_user_session_path, exact: true)
    expect(page).to have_css("a[href='/admin/admin_users/#{admin_user.id}']", text: "admin@example.com")
  end

  it "rejects an unknown email address" do
    visit admin_root_path
    with_translation(%w[devise failure not_found_in_database], "Invalid email or password.") do
      fill_in "Email", with: "not-an-admin@example.com"
      fill_in "Password", with: "not-my-password"
      click_button "Sign In"
      expect(page).to have_text("Sign In")
      expect(page).to have_text("Invalid email or password.")
    end
  end

  it "rejects an incorrect password" do
    visit admin_root_path
    with_translation(%w[devise failure invalid], "Invalid email or password.") do
      fill_in "Email", with: "admin@example.com"
      fill_in "Password", with: "not-my-password"
      click_button "Sign In"
      expect(page).to have_text("Sign In")
      expect(page).to have_text("Invalid email or password.")
    end
  end
end
