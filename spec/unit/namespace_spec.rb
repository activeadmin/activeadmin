require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

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
      it "should be evaluated in the controller" do
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
    end
    
    describe "admin notes" do
      let(:namespace){ ActiveAdmin::Namespace.new(:admin) }
      context "when admin notes are disabled" do
        it "should not call #register_with_admin_notes" do
          namespace.should_not_receive :register_with_admin_notes
          namespace.register Category do
            admin_notes false
          end
        end
      end
      context "when admin notes are enabled" do
        it "should call #register_with_admin_notes" do
          namespace.should_receive :register_with_admin_notes
          namespace.register Category do
            admin_notes true
          end
        end
      end
    end

  end  

end
