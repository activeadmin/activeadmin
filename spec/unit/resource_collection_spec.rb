require 'spec_helper'
require 'active_admin/resource_collection'

include ActiveAdmin

describe ActiveAdmin::ResourceCollection do

  let(:collection){ ResourceCollection.new }

  it "should have no resources when new" do
    collection.resources.should == []
  end

  it "should be enumerable" do
    resource = mock(:resource_key => "MyResource")
    collection.add(resource)
    collection.each{|r| r.should == resource }
  end

  it "should return the available keys" do
    resource = mock(:resource_key => "MyResource")
    collection.add resource
    collection.keys.should == [resource.resource_key]
  end

  describe "adding a new resource" do
    let(:resource){ mock(:resource_key => "MyResource") }

    it "should return the resource" do
      collection.add(resource).should == resource
    end

    it "should add a new resource" do
      collection.add(resource)
      collection.resources.should == [resource]
    end

    it "should be available by name" do
      collection.add(resource)
      collection.find_by_key(resource.resource_key).should == resource
    end
  end

  describe "adding a new resource when the key already exists" do
    let(:stored_resource){ mock(:resource_key => "MyResource") }
    let(:resource){ mock(:resource_key => "MyResource") }

    before do
      collection.add(stored_resource)
    end

    it "should return the original resource" do
      collection.add(resource).should == stored_resource
    end

    it "should not add a new resource" do
      collection.add(resource)
      collection.resources.should == [stored_resource]
    end
  end

  describe "adding an existing resource key with a different resource class" do
    let(:stored_resource){ mock(:resource_key => "MyResource", :resource_class => mock) }
    let(:resource){ mock(:resource_key => "MyResource", :resource_class => mock) }

    it "should raise a ActiveAdmin::ResourceMismatchError" do
      collection.add(stored_resource)
      lambda {
        collection.add(resource)
      }.should raise_error(ActiveAdmin::ResourceMismatchError)
    end

  end

  describe "#find_by_resource_class" do

    let(:base_class){ mock(:to_s => "BaseClass")}
    let(:resource_from_base_class){ mock(:resource_key => "MyBaseClassResource", :resource_class => base_class )}
    let(:resource_class){ mock(:base_class => base_class, :to_s => "ResourceClass") }
    let(:resource){ mock(:resource_key => "MyResource", :resource_class => resource_class) }

    it "should find a resource when it's in the collection" do
      collection.add resource
      collection.find_by_resource_class(resource_class).should == resource
    end

    it "should return nil when the resource class is not in the collection" do
      collection.find_by_resource_class(resource_class).should == nil
    end

    it "should return the resource when it and it's base class is in the collection" do
      collection.add resource_from_base_class
      collection.find_by_resource_class(resource_class).should == resource_from_base_class
    end

    it "should return nil the resource_class does not repond to base_class and it's not in the collection" do
      collection.find_by_resource_class(mock).should == nil
    end
  end

end
