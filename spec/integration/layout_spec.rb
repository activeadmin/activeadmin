require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Layout" do

  it "should include the active admin stylesheet" do
    get :index
    response.should have_tag("link", :attributes => { :href => '/stylesheets/active_admin.css' })
  end

  it "should include active admin vendor js" do
    get :index
    response.should have_tag("script", :attributes => { :src => '/javascripts/active_admin_vendor.js' })
  end

  it "should include active admin js" do
    get :index
    response.should have_tag("script", :attributes => { :src => '/javascripts/active_admin.js' })
  end

  it "should display the site title" do
    get :index
    response.should have_tag("h1", ActiveAdmin.site_title)
  end

  describe "csrf meta tags" do
    # Turn on then off protect against forgery so that our tests
    # will render the required meta tags
    before(:each) do
      class Admin::PostsController
        def protect_against_forgery_with_mock?; true; end
        alias_method_chain :protect_against_forgery?, :mock
      end
    end
    after(:each) do
      Admin::PostsController.send :alias_method, :protect_against_forgery?, :protect_against_forgery_without_mock?
    end
    it "should include the csrf-param meta tag" do
      get :index
      response.should have_tag("meta", :attributes => { :name => "csrf-param" })
    end
    it "should include the csrf-token meta tag" do
      get :index
      response.should have_tag("meta", :attributes => { :name => "csrf-token" })
    end
  end

  describe "tabs" do
    context "when index" do
      before do
        get :index
      end
      it "should generate an ul for tabs" do
        response.should have_tag("ul", :attributes => { :id => "tabs" })
      end
      it "should generate an li and a for each resource" do
        ActiveAdmin.resources.values.each do |r|
          response.should have_tag("a", r.resource_name.pluralize, :parent => {
                                                          :tag => "li" })
        end
      end
      it "should mark the current tab as current" do
        response.should have_tag("li", "Posts", :attributes => {
                                                :class => "current" })
      end
    end
    context "when /new" do
      before do
        get :new
      end
      it "should mark the current tab section as current" do
        response.should have_tag("li", "Posts", :attributes => {
                                                :class => "current" })
      end
    end
  end

end
