require 'spec_helper'

describe ActiveAdmin::ResourceController do
  
  [:index, :show].each do |page|
    describe "#{page} config" do
      before do
        Admin::PostsController.send(:"reset_#{page}_config!")
      end

      it "should be set" do
        Admin::PostsController.send(:set_page_config, page, {})
        Admin::PostsController.send(:"#{page}_config").should be_an_instance_of(ActiveAdmin::PageConfig)
      end

      it "should store the block" do
        block = Proc.new {}
        Admin::PostsController.send(:set_page_config, page, {}, &block)
        Admin::PostsController.send(:"#{page}_config").block.should == block
      end

      it "should be reset" do
        Admin::PostsController.send(:"reset_#{page}_config!")
        Admin::PostsController.send(:"#{page}_config").should == nil
      end
    end
  end

  describe "setting the current tab" do
    let(:controller) { ActiveAdmin::ResourceController.new }
    before do 
      controller.stub!(:active_admin_config => resource, :parent? => true)
      controller.send :set_current_tab # Run the before filter
    end
    subject{ controller.instance_variable_get(:@current_tab) }

    context "when menu item name is 'Resources' without a parent menu item" do
      let(:resource){ mock(:menu_item_name => "Resources", :parent_menu_item_name => nil, :belongs_to? => false) }
      it { should == "Resources" }
    end

    context "when there is a parent menu item of 'Admin'" do
      let(:resource){ mock(:parent_menu_item_name => "Admin", :menu_item_name => "Resources", :belongs_to? => false) }
      it { should == "Admin/Resources" }
    end
  end

  describe "callbacks" do
    let(:application){ ::ActiveAdmin::Application.new }
    let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }

    before :all do
      namespace.register Post do
        after_build :call_after_build
        before_save :call_before_save
        after_save :call_after_save
        before_create :call_before_create
        after_create :call_after_create
        before_update :call_before_update
        after_update :call_after_update
        before_destroy :call_before_destroy
        after_destroy :call_after_destroy

        controller do
          def call_after_build(obj); end
          def call_before_save(obj); end
          def call_after_save(obj); end
          def call_before_create(obj); end
          def call_after_create(obj); end
          def call_before_update(obj); end
          def call_after_update(obj); end
          def call_before_destroy(obj); end
          def call_after_destroy(obj); end
        end
      end
    end

    describe "performing create" do
      let(:controller){ Admin::PostsController.new }
      let(:resource){ mock("Resource", :save => true) }

      before do
        resource.should_receive(:save)
      end

      it "should call the before create callback" do
        controller.should_receive(:call_before_create).with(resource)
        controller.send :create_resource, resource
      end
      it "should call the before save callback" do
        controller.should_receive(:call_before_save).with(resource)
        controller.send :create_resource, resource
      end
      it "should call the after save callback" do
        controller.should_receive(:call_after_save).with(resource)
        controller.send :create_resource, resource
      end
      it "should call the after create callback" do
        controller.should_receive(:call_after_create).with(resource)
        controller.send :create_resource, resource
      end
    end

    describe "performing update" do
      let(:controller){ Admin::PostsController.new }
      let(:resource){ mock("Resource", :attributes= => true, :save => true) }
      let(:attributes){ {} }

      before do
        resource.should_receive(:attributes=).with(attributes)
        resource.should_receive(:save)
      end

      it "should call the before update callback" do
        controller.should_receive(:call_before_update).with(resource)
        controller.send :update_resource, resource, attributes
      end
      it "should call the before save callback" do
        controller.should_receive(:call_before_save).with(resource)
        controller.send :update_resource, resource, attributes
      end
      it "should call the after save callback" do
        controller.should_receive(:call_after_save).with(resource)
        controller.send :update_resource, resource, attributes
      end
      it "should call the after create callback" do
        controller.should_receive(:call_after_update).with(resource)
        controller.send :update_resource, resource, attributes
      end
    end

    describe "performing destroy" do
      let(:controller){ Admin::PostsController.new }
      let(:resource){ mock("Resource", :destroy => true) }

      before do
        resource.should_receive(:destroy)
      end

      it "should call the before destroy callback" do
        controller.should_receive(:call_before_destroy).with(resource)
        controller.send :destroy_resource, resource
      end

      it "should call the after destroy callback" do
        controller.should_receive(:call_after_destroy).with(resource)
        controller.send :destroy_resource, resource
      end
    end
  end

end
