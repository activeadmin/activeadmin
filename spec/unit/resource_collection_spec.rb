require 'rails_helper'
require 'active_admin/resource_collection'

RSpec.describe ActiveAdmin::ResourceCollection do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace)   { ActiveAdmin::Namespace.new application, :admin }
  let(:collection)  { ActiveAdmin::ResourceCollection.new }
  let(:resource)    { double resource_name: "MyResource" }

  it { is_expected.to respond_to :[]       }
  it { is_expected.to respond_to :add      }
  it { is_expected.to respond_to :each     }
  it { is_expected.to respond_to :has_key? }
  it { is_expected.to respond_to :keys     }
  it { is_expected.to respond_to :values   }
  it { is_expected.to respond_to :size     }
  it { is_expected.to respond_to :to_a     }

  it "should have no resources when new" do
    expect(collection).to be_empty
  end

  it "should be enumerable" do
    collection.add(resource)
    collection.each { |r| expect(r).to eq resource }
  end

  it "should return the available keys" do
    collection.add resource
    expect(collection.keys).to eq [resource.resource_name]
  end

  describe "#add" do
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

    it "shouldn't allow a resource name mismatch to occur" do
      expect {
        ActiveAdmin.register Category
        ActiveAdmin.register Post, as: "Category"
      }.to raise_error ActiveAdmin::ResourceCollection::ConfigMismatch
    end

    it "shouldn't allow a Page/Resource mismatch to occur" do
      expect {
        ActiveAdmin.register User
        ActiveAdmin.register_page 'User'
      }.to raise_error ActiveAdmin::ResourceCollection::IncorrectClass
    end

    describe "should store both renamed and non-renamed resources" do
      let(:resource) { ActiveAdmin::Resource.new namespace, Category }
      let(:renamed)  { ActiveAdmin::Resource.new namespace, Category, as: "Subcategory" }

      it "when the renamed version is added first" do
        collection.add renamed
        collection.add resource
        expect(collection.values).to include(resource, renamed)
      end

      it "when the renamed version is added last" do
        collection.add resource
        collection.add renamed
        expect(collection.values).to include(resource, renamed)
      end
    end
  end

  describe "#[]" do
    let(:resource)              { ActiveAdmin::Resource.new namespace, resource_class }
    let(:inherited_resource)    { ActiveAdmin::Resource.new namespace, inherited_resource_class }

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
      let(:renamed_resource) { ActiveAdmin::Resource.new namespace, resource_class, as: name }
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

    context "with a resource and a renamed resource added in disorder" do
      let(:resource) { ActiveAdmin::Resource.new namespace, resource_class }
      let(:renamed_resource) do
        ActiveAdmin::Resource.new namespace, resource_class, as: name
      end
      let(:name) { "Administrators" }

      before do
        collection.add renamed_resource
        collection.add resource
      end

      it "should find a resource by class when there are two resources with that class" do
        expect(collection[resource_class]).to eq resource
      end
    end
  end

  skip "specs for subclasses of Page and Resource"
end
