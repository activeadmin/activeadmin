require 'spec_helper'
require 'fileutils'

describe ActiveAdmin::Application do

  let(:application) do
    ActiveAdmin::Application.new.tap do |app|
      # Manually override the load paths becuase RSpec messes these up
      app.load_paths = [File.expand_path('app/admin', Rails.root)]
    end
  end

  it "should have a default load path of ['app/admin']" do
    application.load_paths.should == [File.expand_path('app/admin', Rails.root)]
  end

  it "should remove app/admin from the autoload path to remove the possibility of conflicts" do
    ActiveSupport::Dependencies.autoload_paths.should_not include(File.join(Rails.root, "app/admin"))
  end

  it "should remove app/admin from the eager load paths (Active Admin deals with loading)" do
    Rails.application.config.eager_load_paths.should_not include(File.join(Rails.root, "app/admin"))
  end

  it "should store the site's title" do
    application.site_title.should == ""
  end

  it "should set the site title" do
    application.site_title = "New Title"
    application.site_title.should == "New Title"
  end
  
  it "should store the site's title link" do
    application.site_title_link.should == ""
  end

  it "should set the site's title link" do
    application.site_title_link = "http://www.mygreatsite.com"
    application.site_title_link.should == "http://www.mygreatsite.com"
  end
  
  it "should store the site's title image" do
    application.site_title_image.should == ""
  end
  
  it "should set the site's title image" do
    application.site_title_image = "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"
    application.site_title_image.should == "http://railscasts.com/assets/episodes/stills/284-active-admin.png?1316476106"
  end

  it "should have a view factory" do
    application.view_factory.should be_an_instance_of(ActiveAdmin::ViewFactory)
  end

  it "should have deprecated admin notes by default" do 
    application.admin_notes.should be_nil
  end

  it "should allow comments by default" do
    application.allow_comments.should == true
  end

  describe "authentication settings" do

    it "should have no default current_user_method" do
      application.current_user_method.should == false
    end

    it "should have no default authentication method" do
      application.authentication_method.should == false
    end

    it "should have a logout link path (Devise's default)" do
      application.logout_link_path.should == :destroy_admin_user_session_path
    end

    it "should have a logout link method (Devise's default)" do
      application.logout_link_method.should == :get
    end
  end

  describe "files in load path" do
    it "should load files in the first level directory" do
      application.files_in_load_path.should include(File.expand_path("app/admin/dashboards.rb", Rails.root))
    end

    it "should load files from subdirectories" do
      FileUtils.mkdir_p(File.expand_path("app/admin/public", Rails.root))
      test_file = File.expand_path("app/admin/public/posts.rb", Rails.root)
      FileUtils.touch(test_file)
      application.files_in_load_path.should include(test_file)
    end
  end

  describe "adding an inheritable setting" do

    it "should add a setting to Application and Namespace" do
      ActiveAdmin::Application.inheritable_setting :inheritable_setting, "inheritable_setting"
      app = ActiveAdmin::Application.new
      app.inheritable_setting.should == "inheritable_setting"
      ns = ActiveAdmin::Namespace.new(app, :admin)
      ns.inheritable_setting.should == "inheritable_setting"
    end

  end

  describe "#namespace" do
    it "should yield a new namespace" do
      application.namespace :new_namespace do |ns|
        ns.name.should == :new_namespace
      end
    end

    it "should return an instantiated namespace" do
      admin = application.find_or_create_namespace :admin
      application.namespace :admin do |ns|
        ns.should == admin
      end
    end
  end

  describe "#register_page" do
    it "finds or create the namespace and register the page to it" do
      namespace = mock
      application.should_receive(:find_or_create_namespace).with("public").and_return namespace
      namespace.should_receive(:register_page).with("My Page", {:namespace => "public"})

      application.register_page("My Page", :namespace => "public")
    end
  end

end
