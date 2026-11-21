# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Signing out", type: :system, js: true do
  it "signs out through the session link" do
    login_as_admin
    visit admin_root_path

    find_by_id("user-menu-button").click

    expect(page).to have_css("a[data-method='delete']", text: "Sign out")

    click_link "Sign out", exact: true

    expect(page).to have_text("Sign In")

    visit admin_root_path

    expect(page).to have_current_path(new_admin_user_session_path)
  end
end
