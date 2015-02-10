require 'rails_helper'

# TODO: refactor this file so it doesn't depend on the Admin namespace in such a broken way.
#       Specifically, the dashboard is already defined.

describe ActiveAdmin::Namespace, "registering a resource" do

  let(:application){ ActiveAdmin::Application.new }

  let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

  let(:menu){ namespace.fetch_menu(:default) }

  context "with no configuration" do
    before do
      namespace.register Category
    end
    it "should store the namespaced registered configuration" do
      expect(namespace.resources.keys).to include('Category')
    end
    it "should create a new controller in the default namespace" do
      expect(defined?(Admin::CategoriesController)).to be_truthy
    end
    skip "should not create the dashboard controller" do
      defined?(Admin::DashboardController).to_not be_truthy
    end
    it "should create a menu item" do
      expect(menu["Categories"]).to be_a ActiveAdmin::MenuItem
      expect(menu["Categories"].instance_variable_get(:@url)).to be_a Proc
    end
  end # context "with no configuration"

  context "with a block configuration" do
    it "should be evaluated in the dsl" do
      expect {
        namespace.register Category do
          raise "Hello World"
        end
      }.to raise_error
    end
  end # context "with a block configuration"

  context "with a resource that's namespaced" do
    before do
      module ::Mock; class Resource; def self.has_many(arg1, arg2); end; end; end
      namespace.register Mock::Resource
    end

    it "should store the namespaced registered configuration" do
      expect(namespace.resources.keys).to include('Mock::Resource')
    end
    it "should create a new controller in the default namespace" do
      expect(defined?(Admin::MockResourcesController)).to be_truthy
    end
    it "should create a menu item" do
      expect(menu["Mock Resources"]).to be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should use the resource as the model in the controller" do
      expect(Admin::MockResourcesController.resource_class).to eq Mock::Resource
    end
  end # context "with a resource that's namespaced"

  describe "finding resource instances" do
    it "should return the resource when its been registered" do
      post = namespace.register Post
      expect(namespace.resource_for(Post)).to eq post
    end

    it 'should return nil when the resource has not been registered' do
      expect(namespace.resource_for(Post)).to eq nil
    end

    it "should return the parent when the parent class has been registered and the child has not" do
      user = namespace.register User
      expect(namespace.resource_for(Publisher)).to eq user
    end

    it "should return the resource if it and it's parent were registered" do
      user = namespace.register User
      publisher = namespace.register Publisher
      expect(namespace.resource_for(Publisher)).to eq publisher
    end
  end # describe "finding resource instances"

  describe "adding to the menu" do
    describe "adding as a top level item" do
      before do
        namespace.register Category
      end
      it "should add a new menu item" do
        expect(menu['Categories']).to_not be_nil
      end
    end # describe "adding as a top level item"

    describe "adding as a child" do
      before do
        namespace.register Category do
          menu parent: 'Blog'
        end
      end
      it "should generate the parent menu item" do
        expect(menu['Blog']).to_not be_nil
      end
      it "should generate its own child item" do
        expect(menu['Blog']['Categories']).to_not be_nil
      end
    end # describe "adding as a child"

    describe "disabling the menu" do
      before do
        namespace.register Category do
          menu false
        end
      end
      it "should not create a menu item" do
        expect(menu["Categories"]).to be_nil
      end
    end # describe "disabling the menu"

    describe "adding as a belongs to" do
      context "when not optional" do
        before do
          namespace.register Post do
            belongs_to :author
          end
        end
        it "should not show up in the menu" do
          expect(menu["Posts"]).to be_nil
        end
      end
      context "when optional" do
        before do
          namespace.register Post do
            belongs_to :author, optional: true
          end
        end
        it "should show up in the menu" do
          expect(menu["Posts"]).to_not be_nil
        end
      end
    end
  end # describe "adding to the menu"

  describe "dashboard controller name" do
    context "when namespaced" do
      it "should be namespaced" do
        namespace = ActiveAdmin::Namespace.new(application, :one)
        namespace.register Category
        expect(defined?(One::CategoriesController)).to be_truthy
      end
    end
    context "when not namespaced" do
      it "should not be namespaced" do
        namespace = ActiveAdmin::Namespace.new(application, :two)
        namespace.register Category
        expect(defined?(Two::CategoriesController)).to be_truthy
      end
    end
  end # describe "dashboard controller name"
end # describe "registering a resource"
