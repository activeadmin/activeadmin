# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Menu", type: :request do
  def have_menu_item(label)
    have_css("#main-menu li a", exact_text: label)
  end

  def have_hidden_menu_item(label)
    have_css("#main-menu .hidden a", exact_text: label)
  end

  def have_nested_menu_item(label)
    have_css("#main-menu li li a", exact_text: label)
  end

  it "hides a resource's item with menu false" do
    load_default_resources { ActiveAdmin.register(Post) { menu false } }

    get admin_root_path

    expect(response_html).to have_menu_item("Dashboard")
    expect(response_html).not_to have_menu_item("Posts")
  end

  it "uses a custom label" do
    load_default_resources { ActiveAdmin.register(Post) { menu label: "Articles" } }

    get admin_root_path

    expect(response_html).to have_menu_item("Articles")
    expect(response_html).not_to have_menu_item("Posts")
  end

  it "adds a non-resource item" do
    load_default_resources do
      ActiveAdmin.application.namespace(:admin).build_menu do |menu|
        menu.add label: "Custom Menu", url: :admin_dashboard_path
      end
    end

    get admin_root_path

    link = response_html.find("#main-menu li a", exact_text: "Custom Menu")
    expect(link[:href]).to eq admin_dashboard_path

    get link[:href]

    expect(response).to have_http_status(:ok)
  end

  it "adds a non-resource item with method delete" do
    load_default_resources do
      ActiveAdmin.application.namespace(:admin).build_menu do |menu|
        menu.add label: "Delete Menu", url: :admin_dashboard_path, html_options: { method: :delete }
      end
    end

    get admin_root_path

    expect(response_html).to have_css("#main-menu li a[data-method='delete']", exact_text: "Delete Menu")
  end

  it "nests a resource under another resource's item" do
    load_default_resources do
      ActiveAdmin.register User
      ActiveAdmin.register(Post) { menu parent: "Users" }
    end

    get admin_root_path

    expect(response_html).to have_menu_item("Users")
    expect(response_html).to have_hidden_menu_item("Posts")

    get admin_users_path

    expect(response_html).to have_css("#main-menu li a.selected", exact_text: "Users")
    expect(response_html).to have_nested_menu_item("Posts")
  end

  it "nests resources under a parent that isn't a resource" do
    load_default_resources do
      ActiveAdmin.register(Category) { menu parent: "Anything" }
      ActiveAdmin.register(Post) { menu parent: "Anything" }
    end

    get admin_root_path

    expect(response_html).to have_css("#main-menu li button, #main-menu li a", text: "Anything")
    expect(response_html).to have_hidden_menu_item("Categories")
    expect(response_html).to have_hidden_menu_item("Posts")
    expect(response_html).to have_nested_menu_item("Categories")
    expect(response_html).to have_nested_menu_item("Posts")
  end

  it "doesn't keep items added with build_menu after the example" do
    load_default_resources

    get admin_root_path

    expect(response_html).to have_menu_item("Dashboard")
    expect(response_html).not_to have_menu_item("Custom Menu")
    expect(response_html).not_to have_menu_item("Delete Menu")
  end
end
