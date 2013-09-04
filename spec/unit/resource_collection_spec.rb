require 'spec_helper'
require 'active_admin/resource_collection'

include ActiveAdmin

describe ActiveAdmin::ResourceCollection do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace)   { ActiveAdmin::Namespace.new(application, :admin) }

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
    let(:resource)              { Resource.new(namespace, resource_class) }
    let(:inherited_resource)    { Resource.new(namespace, inherited_resource_class) }

    let(:resource_class)           { User }
    let(:inherited_resource_class) { Publisher }
    let(:unregistered_class)       { Category }

    context "with resources" do
      before do
        collection.add resource
        collection.add inherited_resource
      end

      it "should find resource by class" do
        collection[resource_class].should == resource
      end

      it "should find resource by class string" do
        collection[resource_class.to_s].should == resource
      end

      it "should find inherited resource by class" do
        collection[inherited_resource_class].should == inherited_resource
      end

      it "should find inherited resource by class string" do
        collection[inherited_resource_class.to_s].should == inherited_resource
      end

      it "should return nil when the resource_class does not respond to base_class and it is not in the collection" do
        collection[mock].should == nil
      end

      it "should return nil when a resource class is NOT in the collection" do
        collection[unregistered_class].should == nil
      end
    end

    context "without inherited resources" do
      before do
        collection.add resource
      end

      it "should find resource by inherited class" do
        collection[inherited_resource_class].should == resource
      end
    end

    context "with a renamed resource" do
      let(:renamed_resource) { Resource.new(namespace, resource_class, :as => name) }
      let(:name)             { "Administrators" }

      before do
        collection.add renamed_resource
      end

      it "should find resource by class" do
        collection[resource_class].should == renamed_resource
      end

      it "should find resource by class string" do
        collection[resource_class.to_s].should == renamed_resource
      end

      it "should find resource by name" do
        collection[name].should == renamed_resource
      end
    end
  end

  describe ".add" do
    let(:resource)         { Resource.new(namespace, Category) }
    let(:resource_renamed) { Resource.new(namespace, Category, as: "Subcategory") }

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
