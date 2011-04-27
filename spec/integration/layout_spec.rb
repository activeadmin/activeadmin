require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Layout" do

  before do
    load_defaults!
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
      self.class.metadata[:behaviour][:describes] = Admin::PostsController
      get :index
      response.should have_tag("meta", :attributes => { :name => "csrf-param" })
    end
    it "should include the csrf-token meta tag" do
      self.class.metadata[:behaviour][:describes] = Admin::PostsController
      get :index
      response.should have_tag("meta", :attributes => { :name => "csrf-token" })
    end
  end

end
