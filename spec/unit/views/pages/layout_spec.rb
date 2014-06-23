require 'rails_helper'

describe ActiveAdmin::Views::Pages::Layout do

  let(:assigns){ {} }
  let(:helpers) do
    helpers = mock_action_view

    allow(helpers).to receive(:active_admin_application).and_return(active_admin_application)
    allow(helpers).to receive(:active_admin_config).and_return(double('Config', action_items?: nil, breadcrumb: nil, sidebar_sections?: nil))
    allow(helpers).to receive(:active_admin_namespace).and_return(active_admin_namespace)
    allow(helpers).to receive(:breadcrumb_links).and_return([])
    allow(helpers).to receive(:content_for).and_return("")
    allow(helpers).to receive(:csrf_meta_tag).and_return("")
    allow(helpers).to receive(:current_active_admin_user).and_return(nil)
    allow(helpers).to receive(:current_active_admin_user?).and_return(false)
    allow(helpers).to receive(:current_menu).and_return(double('Menu', items: []))
    allow(helpers).to receive(:flash).and_return({})
    allow(helpers).to receive(:javascript_path).and_return("/dummy/")
    allow(helpers).to receive(:link_to).and_return("")
    allow(helpers).to receive(:render_or_call_method_or_proc_on).and_return("")
    allow(helpers).to receive(:stylesheet_link_tag).and_return(double(html_safe: ""))
    allow(helpers).to receive(:view_factory).and_return(view_factory)
    allow(helpers).to receive(:params).and_return({controller: 'UsersController', action: 'edit'})

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
