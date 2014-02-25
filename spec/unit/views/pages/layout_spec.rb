require 'spec_helper'

describe ActiveAdmin::Views::Pages::Layout do

  let(:assigns){ {} }
  let(:helpers) do
    helpers = mock_action_view

    helpers.stub active_admin_application: active_admin_application,
                 active_admin_config: double('Config', action_items?: nil, breadcrumb: nil, sidebar_sections?: nil),
                 active_admin_namespace: active_admin_namespace,
                 breadcrumb_links: [],
                 content_for: "",
                 csrf_meta_tag: "",
                 current_active_admin_user: nil,
                 :current_active_admin_user? => false,
                 current_menu: double('Menu', items: []),
                 flash: {},
                 javascript_path: "/dummy/",
                 link_to: "",
                 render_or_call_method_or_proc_on: "",
                 stylesheet_link_tag: double(html_safe: ""),
                 view_factory: view_factory,
                 params: {controller: 'UsersController', action: 'edit'}

    helpers
  end

  let(:active_admin_namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :myspace) }
  let(:active_admin_application){ ActiveAdmin.application }
  let(:view_factory) { ActiveAdmin::ViewFactory.new }

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

  describe "the body" do

    it "should have class 'active_admin'" do
      expect(layout.build.class_list).to include 'active_admin'
    end

    it "should have namespace class" do
      expect(layout.build.class_list).to include "#{active_admin_namespace.name}_namespace"
    end

  end

end
