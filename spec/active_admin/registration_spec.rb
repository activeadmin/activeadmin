require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe "Registering an object to administer" do

  context "with no configuration" do
    it "should call register on the namespace" do
      namespace = ActiveAdmin::Namespace.new(:admin)
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

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
  end

  context "with no namespace" do
    it "should call register on the root namespace" do
      namespace = ActiveAdmin::Namespace.new(:root)
      ActiveAdmin.namespaces[namespace.name] = namespace
      namespace.should_receive(:register)

      ActiveAdmin.register Category, :namespace => false
    end
  end

end
