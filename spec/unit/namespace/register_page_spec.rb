require 'spec_helper' 

describe ActiveAdmin::Namespace, "registering a page" do

  let(:application){ ActiveAdmin::Application.new }

  let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

  context "with no configuration" do
    before do
      namespace.register_page "Status"
    end

    it "should store the namespaced registered configuration" do
      namespace.resources.keys.should include('Status')
    end

    it "should create a new controller in the default namespace" do
      defined?(Admin::StatusController).should be_true
    end

    it "should create a menu item" do
      namespace.load_menu!
      namespace.menu["Status"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end
  end # context "with no configuration"

  context "with a block configuration" do
    it "should be evaluated in the dsl" do
      lambda {
        namespace.register_page "Status" do
          raise "Hello World"
        end
      }.should raise_error
    end
  end # context "with a block configuration"

  describe "adding to the menu" do
    describe "adding as a top level item" do
      before do
        namespace.register_page "Status"
        namespace.load_menu!
      end

      it "should add a new menu item" do
        namespace.menu['Status'].should_not be_nil
      end
    end # describe "adding as a top level item"

    describe "adding as a child" do
      before do
        namespace.register_page "Status" do
          menu :parent => 'Extra'
        end
        namespace.load_menu!
      end
      it "should generate the parent menu item" do
        namespace.menu['Extra'].should_not be_nil
      end
      it "should generate its own child item" do
        namespace.menu['Extra']['Status'].should_not be_nil
      end
    end # describe "adding as a child"

    describe "disabling the menu" do
      before do
        namespace.register_page "Status" do
          menu false
        end
        namespace.load_menu!
      end
      it "should not create a menu item" do
        namespace.menu["Status"].should be_nil
      end
    end # describe "disabling the menu"
    
    describe "setting menu priority" do
      before do
        namespace.register_page "Status" do
          menu :priority => 2
        end
        namespace.load_menu!
      end
      it "should have a custom priority of 2" do
        namespace.menu["Status"].priority.should == 2
      end
    end # describe "setting menu priority"
    
    describe "setting a condition for displaying" do
      before do
        namespace.register_page "Status" do
          menu :if => proc { false }
        end
        namespace.load_menu!
      end
      it "should have a proc returning false" do
        namespace.menu["Status"].display_if_block.should be_instance_of(Proc)
        namespace.menu["Status"].display_if_block.call.should == false
      end
    end # describe "setting a condition for displaying"
  end # describe "adding to the menu"
end
