# frozen_string_literal: true
require "rails_helper"

RSpec.describe "I18n", type: :system do
  around { |example| I18n.with_locale(:en) { example.run } }

  before do
    login_as_admin
  end

  it "store's model name was translated to \"Bookstore\"" do
    Store.create!(name: "Hello words")
    visit admin_root_path

    expect(page).to have_text("Bookstores")

    click_link "Bookstores", exact: true

    expect(page).to have_page_title("Bookstores")
    expect(page).to have_text("Hello words")

    click_link "View", exact: true

    expect(page).to have_text("Hello words")
    expect(page).to have_link("Delete Bookstore", exact: true)

    click_link "Edit Bookstore", exact: true

    expect(page).to have_text("Edit Bookstore")

    click_button "Update Bookstore"

    expect(page).to have_text("Bookstore was successfully updated.")
  end

  it "switching language at runtime" do
    I18n.locale = :fr
    visit admin_root_path

    expect(page).to have_text("Store")
    expect(page).to have_text("Déconnexion")
    I18n.locale = :en
    visit admin_root_path

    expect(page).to have_text("Bookstore")
    expect(page).to have_text("Sign out")
  end

  it "overriding translations" do
    Store.create!(name: "Hello words")
    visit admin_root_path
    click_link "Bookstores", exact: true

    expect(page).to have_text("Export:")
  end
end
