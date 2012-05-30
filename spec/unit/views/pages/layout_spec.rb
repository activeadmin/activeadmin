require 'spec_helper'

describe ActiveAdmin::Views::Pages::Layout do

  describe "the page title" do

    it "should be the @page_title if assigned in the controller" do
      assigns = {:page_title => "My Page Title"}
      layout = ActiveAdmin::Views::Pages::Layout.new(assigns, nil)
      layout.title.should == "My Page Title"
    end

    it "should be the default translation" do
      assigns = {}
      helpers = mock(:params => {:action => 'edit'})
      layout = ActiveAdmin::Views::Pages::Layout.new(assigns, helpers)
      layout.title.should == "Edit"
    end

  end

  describe "the body" do

    let(:active_admin_namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :myspace) }
    let(:active_admin_application){ ActiveAdmin.application }
    let(:view_factory) { ActiveAdmin::ViewFactory.new }

    before(:each) do 
      @assigns = {}
      @helpers = mock('Helpers',
                      :active_admin_application => active_admin_application,
                      :active_admin_config => mock('Config', :action_items? => nil, :sidebar_sections? => nil),
                      :active_admin_namespace => active_admin_namespace,
                      :breadcrumb_links => [],
                      :content_for => "",
                      :csrf_meta_tag => "",
                      :current_active_admin_user => nil,
                      :current_active_admin_user? => false,
                      :current_menu => mock('Menu', :items => []),
                      :flash => {},
                      :javascript_path => "/dummy/",
                      :link_to => "",
                      :render_or_call_method_or_proc_on => "",
                      :stylesheet_link_tag => mock(:html_safe => ""),
                      :view_factory => view_factory,
                      :params => {:controller => 'UsersController', :action => 'edit'})
    end


    it "should have class 'active_admin'" do
      layout = ActiveAdmin::Views::Pages::Layout.new(@assigns, @helpers)
      layout.build.class_list.should include 'active_admin'
    end

    it "should have namespace class" do
      layout = ActiveAdmin::Views::Pages::Layout.new(@assigns, @helpers)
      layout.build.class_list.should include "#{active_admin_namespace.name}_namespace"
    end

  end

end
