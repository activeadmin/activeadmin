# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Theme selection", type: :system, js: true do
  before do
    login_as_admin
    visit admin_root_path
    page.execute_script("localStorage.removeItem('theme')")
    emulate_color_scheme("light")
    page.refresh
  end

  after do
    page.execute_script("localStorage.removeItem('theme')")
    page.driver.browser.page.command("Emulation.setEmulatedMedia", features: [])
  end

  def emulate_color_scheme(value)
    page.driver.browser.page.command(
      "Emulation.setEmulatedMedia",
      features: [{ name: "prefers-color-scheme", value: value }]
    )
  end

  it "keeps the selected theme through navigation and reloads" do
    expect(page).to have_no_css("html.dark")
    click_button class: "dark-mode-toggle"

    expect(page).to have_css("html.dark")
    expect(page.evaluate_script("localStorage.getItem('theme')")).to eq("dark")

    within("#main-menu") { click_link "Companies", exact: true }

    expect(page).to have_current_path(admin_companies_path)
    expect(page).to have_css("html.dark")
    page.refresh

    expect(page).to have_css("html.dark")
    click_button class: "dark-mode-toggle"

    expect(page).to have_no_css("html.dark")
    expect(page.evaluate_script("localStorage.getItem('theme')")).to eq("light")
    page.refresh

    expect(page).to have_no_css("html.dark")
  end

  it "follows the system preference until the user selects a theme" do
    emulate_color_scheme("dark")
    page.refresh

    expect(page).to have_css("html.dark")
    expect(page.evaluate_script("localStorage.getItem('theme')")).to be_nil

    emulate_color_scheme("light")

    expect(page).to have_no_css("html.dark")
    expect(page.evaluate_script("localStorage.getItem('theme')")).to be_nil
  end

  it "keeps an explicit light theme when the system preference is dark" do
    emulate_color_scheme("dark")
    page.refresh

    expect(page).to have_css("html.dark")
    click_button class: "dark-mode-toggle"

    expect(page).to have_no_css("html.dark")
    expect(page.evaluate_script("localStorage.getItem('theme')")).to eq("light")
    page.refresh

    expect(page).to have_no_css("html.dark")
  end
end
