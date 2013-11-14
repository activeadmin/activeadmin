require 'spec_helper'
require 'active_admin/resource_collection'

include ActiveAdmin

describe ActiveAdmin::ResourceCollection do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace)   { ActiveAdmin::Namespace.new(application, :admin) }

  let(:collection){ ResourceCollection.new }

  let(:resource){ double resource_name: "MyResource" }

  it "should have no resources when new" do
    expect(collection).to be_empty
  end

  it "should be enumerable" do
    collection.add(resource)
    collection.each{ |r| expect(r).to eq resource }
  end

  it "should return the available keys" do
    collection.add resource
    expect(collection.keys).to eq [resource.resource_name]
  end

  describe "adding a new resource" do
    it "should return the resource" do
      expect(collection.add(resource)).to eq resource
    end

    it "should add a new resource" do
      collection.add(resource)
      expect(collection.values).to eq [resource]
    end

    it "should be available by name" do
      collection.add(resource)
      expect(collection[resource.resource_name]).to eq resource
    end

    it "shouldn't happen twice" do
      collection.add(resource); collection.add(resource)
      expect(collection.values).to eq [resource]
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
        expect(collection[resource_class]).to eq resource
      end

      it "should find resource by class string" do
        expect(collection[resource_class.to_s]).to eq resource
      end

      it "should find inherited resource by class" do
        expect(collection[inherited_resource_class]).to eq inherited_resource
      end

      it "should find inherited resource by class string" do
        expect(collection[inherited_resource_class.to_s]).to eq inherited_resource
      end

      it "should return nil when the resource_class does not respond to base_class and it is not in the collection" do
        expect(collection[double]).to eq nil
      end

      it "should return nil when a resource class is NOT in the collection" do
        expect(collection[unregistered_class]).to eq nil
      end
    end

    context "without inherited resources" do
      before do
        collection.add resource
      end

      it "should find resource by inherited class" do
        expect(collection[inherited_resource_class]).to eq resource
      end
    end

    context "with a renamed resource" do
      let(:renamed_resource) { Resource.new(namespace, resource_class, :as => name) }
      let(:name)             { "Administrators" }

      before do
        collection.add renamed_resource
      end

      it "should find resource by class" do
        expect(collection[resource_class]).to eq renamed_resource
      end

      it "should find resource by class string" do
        expect(collection[resource_class.to_s]).to eq renamed_resource
      end

      it "should find resource by name" do
        expect(collection[name]).to eq renamed_resource
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
        expect(collection.values).to include(resource, resource_renamed)
      end
    end

    context "when resource is added first" do
      before do
        collection.add(resource)
        collection.add(resource_renamed)
      end

      it "contains both resources" do
        expect(collection.values).to include(resource, resource_renamed)
      end
    end

    context "when a duplicate resource is added" do
      let(:resource_duplicate) { Resource.new(namespace, Category) }

      before do
        collection.add(resource)
        collection.add(resource_duplicate)
      end

      it "the collection contains one instance of that resource" do
        expect(collection.values).to eq([resource])
      end
    end
  end

end
