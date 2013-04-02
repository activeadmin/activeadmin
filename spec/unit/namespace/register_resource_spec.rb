require 'spec_helper' 

describe ActiveAdmin::Namespace, "registering a resource" do

  let(:application){ ActiveAdmin::Application.new }

  let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

  let(:menu){ namespace.fetch_menu(:default) }

  context "with no configuration" do
    before do
      namespace.register Category
    end
    it "should store the namespaced registered configuration" do
      namespace.resources.keys.should include('Category')
    end
    it "should create a new controller in the default namespace" do
      defined?(Admin::CategoriesController).should be_true
    end
    it "should create the dashboard controller" do
      defined?(Admin::DashboardController).should be_true
    end
    it "should create a menu item" do
      menu["Categories"].should be_a ActiveAdmin::MenuItem
      menu["Categories"].instance_variable_get(:@url).should be_a Proc
    end
  end # context "with no configuration"

  context "with a block configuration" do
    it "should be evaluated in the dsl" do
      lambda {
        namespace.register Category do
          raise "Hello World"
        end
      }.should raise_error
    end
  end # context "with a block configuration"

  context "with a resource that's namespaced" do
    before do
      module ::Mock; class Resource; def self.has_many(arg1, arg2); end; end; end
      namespace.register Mock::Resource
    end

    it "should store the namespaced registered configuration" do
      namespace.resources.keys.should include('Mock::Resource')
    end
    it "should create a new controller in the default namespace" do
      defined?(Admin::MockResourcesController).should be_true
    end
    it "should create a menu item" do
      menu["Mock Resources"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should use the resource as the model in the controller" do
      Admin::MockResourcesController.resource_class.should == Mock::Resource
    end
  end # context "with a resource that's namespaced"

  describe "finding resource instances" do
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    it "should return the resource when its been registered" do
      post = namespace.register Post
      namespace.resource_for(Post).should == post
    end

    it 'should return nil when the resource has not been registered' do
      namespace.resource_for(Post).should == nil
    end

    it "should return the parent when the parent class has been registered and the child has not" do
      user = namespace.register User
      namespace.resource_for(Publisher).should == user
    end

    it "should return the resource if it and it's parent were registered" do
      user = namespace.register User
      publisher = namespace.register Publisher
      namespace.resource_for(Publisher).should == publisher
    end
  end # describe "finding resource instances"

  describe "adding to the menu" do
    describe "adding as a top level item" do
      before do
        namespace.register Category
      end
      it "should add a new menu item" do
        menu['Categories'].should_not be_nil
      end
    end # describe "adding as a top level item"

    describe "adding as a child" do
      before do
        namespace.register Category do
          menu :parent => 'Blog'
        end
      end
      it "should generate the parent menu item" do
        menu['Blog'].should_not be_nil
      end
      it "should generate its own child item" do
        menu['Blog']['Categories'].should_not be_nil
      end
    end # describe "adding as a child"

    describe "disabling the menu" do
      before do
        namespace.register Category do
          menu false
        end
      end
      it "should not create a menu item" do
        menu["Categories"].should be_nil
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
          menu["Posts"].should be_nil
        end
      end
      context "when optional" do
        before do
          namespace.register Post do
            belongs_to :author, :optional => true
          end
        end
        it "should show up in the menu" do
          menu["Posts"].should_not be_nil
        end
      end
    end
  end # describe "adding to the menu"

  describe "dashboard controller name" do
    context "when namespaced" do
      it "should be namespaced" do
        namespace = ActiveAdmin::Namespace.new(application, :admin)
        namespace.dashboard_controller_name.should == "Admin::DashboardController"
      end
    end
    context "when not namespaced" do
      it "should not be namespaced" do
        namespace = ActiveAdmin::Namespace.new(application, :root)
        namespace.dashboard_controller_name.should == "DashboardController"
      end
    end
  end # describe "dashboard controller name"
end # describe "registering a resource"
