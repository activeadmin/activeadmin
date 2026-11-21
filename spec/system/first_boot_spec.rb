# frozen_string_literal: true
require "rails_helper"

RSpec.describe "First boot", type: :system do
  it "signs in with only the installed dashboard and built-in comments" do
    # Start with a clean configuration; this setup is not required to test sign-in.
    set_application_setting(:load_paths, [])
    register_resources do
      ActiveAdmin.application.load(Rails.root.join("app/admin/dashboard.rb"))
    end
    resources = ActiveAdmin.application.namespace(:admin).resources.values
    expect(resources.grep(ActiveAdmin::Resource).map(&:resource_class)).to eq([ActiveAdmin::Comment])

    AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password")

    visit admin_root_path
    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign In"

    expect(page).to have_current_path(admin_root_path)
  end
end
