require 'spec_helper'
require 'active_admin/resource_collection'

include ActiveAdmin

describe ActiveAdmin::ResourceCollection do

  let(:collection){ ResourceCollection.new }

  it "should have no resources when new" do
    collection.should be_empty
  end

  it "should be enumerable" do
    resource = mock :resource_name => "MyResource"
    collection.add(resource)
    collection.each{ |r| r.should == resource }
  end

  it "should return the available keys" do
    resource = mock :resource_name => "MyResource"
    collection.add resource
    collection.keys.should == [resource.resource_name]
  end

  describe "adding a new resource" do
    let(:resource){ mock :resource_name => "MyResource" }

    it "should return the resource" do
      collection.add(resource).should == resource
    end

    it "should add a new resource" do
      collection.add(resource)
      collection.values.should == [resource]
    end

    it "should be available by name" do
      collection.add(resource)
      collection[resource.resource_name].should == resource
    end
  end

  describe "adding a new resource when the key already exists" do
    let(:resource){ mock :resource_name => "MyResource" }

    it "should not add a new resource" do
      collection.add(resource); collection.add(resource)
      collection.values.should == [resource]
    end
  end

  describe "#[]" do

    let(:base_class){               mock :to_s => "BaseClass" }
    let(:resource_class){           mock :to_s => "ResourceClass", :base_class => base_class }
    let(:resource_name){            mock :name => "MyResource", :to_s => "MyResource" }
    let(:base_class_resource_name){ mock :name => "MyBaseClassResource", :to_s => "MyBaseClassResource" }
    let(:resource){                 mock :resource_name => resource_name, :resource_class => resource_class }
    let(:from_base_class){          mock :resource_name => base_class_resource_name, :resource_class => base_class }

    it "should find a resource when it's in the collection" do
      collection.add resource
      collection[resource_class].should == resource
    end

    it "should return nil when the resource class is not in the collection" do
      collection[resource_class].should == nil
    end

    it "should return the resource when it and it's base class is in the collection" do
      collection.add from_base_class
      collection[resource_class].should == from_base_class
    end

    it "should return nil the resource_class does not repond to base_class and it's not in the collection" do
      collection[mock].should == nil
    end

    it "should find a resource when it's looked up by a resource name string" do
      collection.add resource
      collection["MyResource"].should == resource
    end
  end

  describe ".add" do
    let(:application)      { ActiveAdmin::Application.new }
    let(:namespace)        { ActiveAdmin::Namespace.new(application, :admin) }

    let(:resource)         { ActiveAdmin::Resource.new(namespace, Category) }
    let(:resource_renamed) { ActiveAdmin::Resource.new(namespace, Category, as: "SubCategory") }

    context "when renamed resource is added first" do
      before do
        collection.add(resource_renamed)
        collection.add(resource)
      end

      it "contains both resources" do
        collection.values.should include(resource, resource_renamed)
      end
    end

    context "when resource is added first" do
      before do
        collection.add(resource)
        collection.add(resource_renamed)
      end

      it "contains both resources" do
        collection.values.should include(resource, resource_renamed)
      end
    end
  end

end
