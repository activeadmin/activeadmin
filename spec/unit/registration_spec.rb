require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe "Registering an object to administer" do

  context "with no configuration" do
    let(:namespace) { ActiveAdmin::Namespace.new(:admin) }
    it "should call register on the namespace" do
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category
    end
     
    it "should have many admin comments" do
      namespace.register Category
      Category.reflect_on_association(:admin_comments).macro.should == :has_many
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
  end

  context "with no namespace" do
    it "should call register on the root namespace" do
      namespace = ActiveAdmin::Namespace.new(:root)
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category, :namespace => false
    end

    it "should generate a path to the dashboard" do
      ActiveAdmin.register Category, :namespace => false
      reload_routes!
      Rails.application.routes.url_helpers.methods.collect(&:to_s).should include("dashboard_path")
    end
  end

end
