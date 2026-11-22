# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Password reset", type: :system do
  let!(:admin_user) { AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password") }

  it "sends password reset instructions" do
    visit admin_root_path
    click_link "Forgot your password?", exact: true
    fill_in "Email", with: "admin@example.com"
    click_button "Reset My Password"

    expect(page).to have_text("You will receive an email with instructions on how to reset your password in a few minutes.")
  end

  it "changes the password with a valid token" do
    visit new_admin_user_password_path
    fill_in "Email", with: "admin@example.com"
    allow(Devise).to receive(:friendly_token).and_return("foobarbaz")
    click_button "Reset My Password"
    visit edit_admin_user_password_path(reset_password_token: "foobarbaz")
    fill_in "admin_user_password", with: "new-password"
    fill_in "Password confirmation", with: "new-password"
    click_button "Change my password"

    expect(page).to have_text("Your password has been changed successfully.")
    expect(admin_user.reload.valid_password?("new-password")).to be(true)
    expect(admin_user.reset_password_token).to be_nil
  end

  it "rejects an expired token" do
    visit new_admin_user_password_path
    fill_in "Email", with: "admin@example.com"
    allow(Devise).to receive(:friendly_token).and_return("foobarbaz")
    click_button "Reset My Password"
    admin_user.update!(reset_password_sent_at: 1.month.ago)
    visit edit_admin_user_password_path(reset_password_token: "foobarbaz")
    fill_in "admin_user_password", with: "new-password"
    fill_in "Password confirmation", with: "new-password"
    click_button "Change my password"

    expect(page).to have_text("expired")
    expect(admin_user.reload.valid_password?("password")).to be(true)
    expect(admin_user.valid_password?("new-password")).to be(false)
  end
end
