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

    it "should not have any menu item" do
      if ActiveAdmin::Dashboards.built?
        # DEPRECATED behavior. If a dashboard was built while running this
        # spec, then an item gets added to the menu
        namespace.fetch_menu(:default).children.should_not be_empty
      else
        namespace.fetch_menu(:default).children.should be_empty
      end
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


  describe "#fetch_menu" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    it "returns the menu" do
      namespace.fetch_menu(:default).should be_an_instance_of(ActiveAdmin::Menu)
    end

    it "should have utility nav menu" do
      namespace.fetch_menu(:utility_navigation).should be_an_instance_of(ActiveAdmin::Menu)
    end

    it "should raise an exception if the menu doesn't exist" do
      expect {
        namespace.fetch_menu(:not_a_menu_that_exists)
      }.to raise_error(KeyError)
    end
  end

  describe "#build_menu" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    it "should set the block as a menu build callback" do
      namespace.build_menu do |menu|
        menu.add :label => "menu item"
      end

      namespace.fetch_menu(:default)["menu item"].should_not be_nil
    end

    it "should set a block on a custom menu" do
      namespace.build_menu :test do |menu|
        menu.add :label => "menu item"
      end

      namespace.fetch_menu(:test)["menu item"].should_not be_nil
    end
  end

  describe "utility navigation" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }
    let(:menu) do 
      namespace.build_menu :utility_navigation do |menu|
        menu.add :label => "ActiveAdmin.info", :url => "http://www.activeadmin.info", :html_options => { :target => :blank }
        namespace.add_logout_button_to_menu menu, 1, :class => "matt"
      end
      namespace.fetch_menu(:utility_navigation)
    end

    it "should have a logout button to the far left" do
      menu["Logout"].should_not be_nil
      menu["Logout"].priority.should == 1
    end

    it "should have a static link with a target of :blank" do
      menu["ActiveAdmin.info"].should_not be_nil
      menu["ActiveAdmin.info"].html_options.should include(:target => :blank)
    end

  end

end
