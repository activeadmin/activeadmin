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

  it "should have a view factory" do
    application.view_factory.should be_an_instance_of(ActiveAdmin::ViewFactory)
  end

  it "should have deprecated admin notes by default" do 
    application.admin_notes.should be_nil
  end

  it "should have admin notes in admin namespace by default" do
    application.allow_comments_in.should == [:admin]
  end

  describe "authentication settings" do

    it "should have no default current_user_method" do
      application.current_user_method.should == false
    end

    it "should have no default authentication method" do
      application.authentication_method.should == false
    end

    it "should have a logout link path" do
      application.logout_link_path.should == nil
    end

    it "should have a logout link method" do
      application.logout_link_method.should == nil
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

end
