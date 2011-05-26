require 'spec_helper' 

describe ActiveAdmin::Namespace do

  context "when new" do
    let(:namespace){ ActiveAdmin::Namespace.new(:admin) }

    it "should have a name" do
      namespace.name.should == :admin
    end

    it "should have no resources" do
      namespace.resources.should == {}
    end

    it "should have an empty menu" do
      namespace.menu.items.should be_empty
    end
  end

  describe "registering a resource" do

    let(:namespace){ ActiveAdmin::Namespace.new(:admin) }

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
        namespace.load_menu!
        namespace.menu["Categories"].should be_an_instance_of(ActiveAdmin::MenuItem)
        namespace.menu["Categories"].url.should == "/admin/categories"
      end
    end

    context "with a block configuration" do
      it "should be evaluated in the dsl" do
        lambda {
          namespace.register Category do
            raise "Hello World"
          end
        }.should raise_error
      end
    end

    context "with a resource that's namespaced" do
      before do
        module ::Mock; class Resource; def self.has_many(arg1, arg2); end; end; end
        namespace.register Mock::Resource
      end
      
      it "should store the namespaced registered configuration" do
        namespace.resources.keys.should include('MockResource')
      end
      it "should create a new controller in the default namespace" do
        defined?(Admin::MockResourcesController).should be_true
      end
      it "should create a menu item" do
        namespace.load_menu!
        namespace.menu["Mock Resources"].should be_an_instance_of(ActiveAdmin::MenuItem)
      end
      it "should use the resource as the model in the controller" do
        Admin::MockResourcesController.resource_class.should == Mock::Resource
      end
    end

    describe "finding resource instances" do
      let(:namespace){ ActiveAdmin::Namespace.new(:admin) }
      context "when registered" do
        before do
          @post_resource = namespace.register Post
        end
        it "should return the resource instance" do
          namespace.resource_for(Post).should == @post_resource
        end
      end
      context "when not registered" do
        it "should be nil" do
          namespace.resource_for(Post).should == nil
        end
      end
    end

    describe "adding to the menu" do

      describe "adding as a top level item" do
        before do
          namespace.register Category
          namespace.load_menu!
        end
        it "should add a new menu item" do
          namespace.menu['Categories'].should_not be_nil
        end
      end

      describe "adding as a child" do
        before do
          namespace.register Category do
            menu :parent => 'Blog'
          end
          namespace.load_menu!
        end
        it "should generate the parent menu item" do
          namespace.menu['Blog'].should_not be_nil
        end
        it "should generate its own child item" do
          namespace.menu['Blog']['Categories'].should_not be_nil
        end
      end

      describe "disabling the menu" do
        # TODO
        it "should not create a menu item"
      end

      describe "adding as a belongs to" do
        context "when not optional" do
          before do
            namespace.register Post do
              belongs_to :author
            end
          end
          it "should not show up in the menu" do
            namespace.menu["Posts"].should be_nil
          end
        end
        context "when optional" do
          before do
            namespace.register Post do
              belongs_to :author, :optional => true
            end
          end
          it "should show up in the menu" do
            namespace.menu["Posts"].should_not be_nil
          end
        end
      end
    end

    describe "dashboard controller name" do
      context "when namespaced" do
        it "should be namespaced" do
          namespace = ActiveAdmin::Namespace.new(:admin)
          namespace.dashboard_controller_name.should == "Admin::DashboardController"
        end
      end
      context "when not namespaced" do
        it "should not be namespaced" do
          namespace = ActiveAdmin::Namespace.new(:root)
          namespace.dashboard_controller_name.should == "DashboardController"
        end
      end
    end

  end
end
