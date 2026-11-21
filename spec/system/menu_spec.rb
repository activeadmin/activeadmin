# frozen_string_literal: true
require "rails_helper"

# Using the main menu in a browser. Nested items are hidden until their
# parent is expanded, which takes JavaScript (main_menu.js), so this runs
# with js: true. How the menu is configured and rendered is covered by
# spec/requests/menu_spec.rb.
RSpec.describe "Main menu", type: :system, js: true do
  before { login_as_admin }

  def nested_item(label)
    find("#main-menu li li a", exact_text: label)
  end

  it "expands a resource's item to reach the resources nested under it" do
    register_resources do
      ActiveAdmin.register User
      ActiveAdmin.register(Post) { menu parent: "Users" }
    end

    visit admin_root_path

    expect(page).to have_css("#main-menu li a", exact_text: "Users")
    expect(page).to have_no_css("#main-menu li li a", exact_text: "Posts")

    find("#main-menu li[data-item-id='users'] button[aria-label='Toggle section']").click
    nested_item("Posts").click

    expect(page).to have_current_path(admin_posts_path)
    expect(page).to have_css("#main-menu li[data-item-id='users'][data-open]")
    expect(page).to have_css("#main-menu li li a.selected", exact_text: "Posts")
  end

  it "expands and collapses a parent that's only a label" do
    register_resources do
      ActiveAdmin.register(Category) { menu parent: "Anything" }
      ActiveAdmin.register(Post) { menu parent: "Anything" }
    end

    visit admin_root_path
    parent = find("#main-menu button[data-menu-button]", text: "Anything")

    expect(page).to have_no_css("#main-menu li li a", exact_text: "Categories")

    parent.click

    expect(nested_item("Categories")).to be_visible
    expect(nested_item("Posts")).to be_visible

    parent.click

    expect(page).to have_no_css("#main-menu li li a", exact_text: "Categories")

    parent.click
    nested_item("Categories").click

    expect(page).to have_current_path(admin_categories_path)
    expect(page).to have_css("#main-menu li li a.selected", exact_text: "Categories")
    expect(page).to have_css("#main-menu li li a", exact_text: "Posts")
  end
end
