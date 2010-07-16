require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe "Registering an object to administer" do

  context "with no configuration" do
    before do
      ActiveAdmin.register Category
    end
    it "should store the registered configuration" do
      ActiveAdmin.resources.keys.should include('Category')
    end
    it "should create a new controller in the default namespace" do
      defined?(Admin::CategoriesController).should be_true
    end
  end

  context "with a different namespace" do
    before do
      ActiveAdmin.register Category, :namespace => :hello_world
    end
    it "should register the controller" do
      defined?(HelloWorld::CategoriesController).should be_true
    end
  end

  context "with no namespace" do
    before do
      ActiveAdmin.register Category, :namespace => false
    end
    it "should register the controller" do
      defined?(CategoriesController).should be_true
    end
  end

  context "with a block configuration" do
    it "should be evaluated in the controller" do
      lambda {
        ActiveAdmin.register Category do
          raise "Hello World"
        end
      }.should raise_error
    end
  end

end
