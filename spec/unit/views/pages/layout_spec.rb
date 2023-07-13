# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Pages::Layout do
  let(:active_admin_application) { ActiveAdmin::Application.new }
  let(:active_admin_namespace) { ActiveAdmin::Namespace.new(active_admin_application, :myspace) }
  let(:assigns) { {} }
  let(:helpers) do
    helpers = mock_action_view

    { active_admin_application: active_admin_application,
      active_admin_config: double("Config", action_items?: nil, breadcrumb: nil, sidebar_sections?: nil),
      active_admin_namespace: active_admin_namespace,
      csrf_meta_tags: "",
      csp_meta_tag: "",
      current_active_admin_user: nil,
      current_active_admin_user?: false,
      current_menu: double("Menu", items: []),
      params: { controller: "UsersController", action: "edit" },
      env: {}
    }.each do |method, returns|
      allow(helpers).to receive(method).and_return returns
    end

    helpers
  end

  let(:layout) do
    render_arbre_component assigns, helpers do
      insert_tag ActiveAdmin::Views::Pages::Layout
    end
  end

  it "should be the @page_title if assigned in the controller" do
    assigns[:page_title] = "My Page Title"

    expect(layout.title).to eq "My Page Title"
  end

  it "should be the default translation" do
    helpers.params[:action] = "edit"

    expect(layout.title).to eq "Edit"
  end

  it "should have lang attribute on the html element" do
    expect(layout.attributes[:lang]).to eq :en
  end
end
