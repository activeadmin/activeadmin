require 'spec_helper' 

describe "Registering an object to administer" do

  context "with no configuration" do
    let(:namespace) { ActiveAdmin::Namespace.new(:admin) }
    it "should call register on the namespace" do
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category
    end

    it "should dispatch a Resource::RegisterEvent" do
      ActiveAdmin::Event.should_receive(:dispatch).with(ActiveAdmin::Resource::RegisterEvent, an_instance_of(ActiveAdmin::Resource))
      ActiveAdmin.register Category
    end
  end

  context "with a different namespace" do
    it "should call register on the namespace" do
      namespace = ActiveAdmin::Namespace.new(:hello_world)
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category, :namespace => :hello_world
    end
    it "should generate a path to the dashboard" do
      ActiveAdmin.register Category, :namespace => :hello_world
      reload_routes!
      Rails.application.routes.url_helpers.methods.collect(&:to_s).should include("hello_world_dashboard_path")
    end
    it "should generate a menu item for the dashboard" do
      ActiveAdmin.register Category, :namespace => :hello_world
      ActiveAdmin.namespaces[:hello_world].load_menu!
      ActiveAdmin.namespaces[:hello_world].menu['Dashboard'].instance_variable_get("@url").should == :hello_world_dashboard_path
    end
    it "should generate a Namespace::RegisterEvent and a Resource::RegisterEvent" do
      ActiveAdmin::Event.should_receive(:dispatch).with(ActiveAdmin::Namespace::RegisterEvent, an_instance_of(ActiveAdmin::Namespace))
      ActiveAdmin::Event.should_receive(:dispatch).with(ActiveAdmin::Resource::RegisterEvent, an_instance_of(ActiveAdmin::Resource))
      ActiveAdmin.register Category, :namespace => :not_yet_created
    end
  end

  context "with no namespace" do
    it "should call register on the root namespace" do
      namespace = ActiveAdmin::Namespace.new(:root)
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category, :namespace => false
    end

    it "should generate a menu item for the dashboard" do
      ActiveAdmin.register Category, :namespace => false  
      ActiveAdmin.namespaces[:root].load_menu!
      ActiveAdmin.namespaces[:root].menu['Dashboard'].instance_variable_get("@url").should == :dashboard_path
    end

    it "should generate a path to the dashboard" do
      ActiveAdmin.register Category, :namespace => false
      reload_routes!
      Rails.application.routes.url_helpers.methods.collect(&:to_s).should include("dashboard_path")
    end
  end

  context "when being registered multiple times" do
    it "should run the dsl in the same config object" do
      config_1 = ActiveAdmin.register(Category) { filter :name }
      config_2 = ActiveAdmin.register(Category) { filter :id }
      config_1.should == config_2
      config_1.controller.filters_config.size.should == 2
    end

    context "with different resource classes" do
      it "should raise an ActiveAdmin::ResourceMismatch" do
        lambda {
          ActiveAdmin.register Category
          ActiveAdmin.register Post, :as => "Category"
        }.should raise_error(ActiveAdmin::ResourceMismatchError)
      end
    end
  end

end
