require 'spec_helper' 

describe ActiveAdmin::Namespace do

  let(:application){ ActiveAdmin::Application.new }

  context "when new" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    it "should have an application instance" do
      namespace.application.should == application
    end

    it "should have a name" do
      namespace.name.should == :admin
    end

    it "should have no resources" do
      namespace.resources.resources.should be_empty
    end

    it "should have one menu item (dashboard)" do
      namespace.menu.items.size.should == 1
    end
  end # context "when new"

  describe "settings" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    it "should inherit the site title from the application" do
      ActiveAdmin::Namespace.setting :site_title, "Not the Same"
      namespace.site_title.should == application.site_title
    end

    it "should be able to override the site title" do
      namespace.site_title.should == application.site_title
      namespace.site_title = "My Site Title"
      namespace.site_title.should_not == application.site_title
    end
  end

end
