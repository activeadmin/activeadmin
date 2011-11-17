require 'spec_helper'
require File.expand_path('base_controller_shared_examples', File.dirname(__FILE__))

describe ActiveAdmin::ResourceController do

  let(:controller) { ActiveAdmin::ResourceController.new }

  it_should_behave_like "BaseController"

  describe "authenticating the user" do
    let(:controller){ Admin::PostsController.new }

    it "should do nothing when no authentication_method set" do
      namespace = controller.class.active_admin_config.namespace
      namespace.should_receive(:authentication_method).once.and_return(nil)

      controller.send(:authenticate_active_admin_user)
    end

    it "should call the authentication_method when set" do
      namespace = controller.class.active_admin_config.namespace

      namespace.should_receive(:authentication_method).twice.
        and_return(:authenticate_admin_user!)

      controller.should_receive(:authenticate_admin_user!).and_return(true)

      controller.send(:authenticate_active_admin_user)
    end

  end

  describe "retrieving the current user" do
    let(:controller){ Admin::PostsController.new }

    it "should return nil when no current_user_method set" do
      namespace = controller.class.active_admin_config.namespace
      namespace.should_receive(:current_user_method).once.and_return(nil)

      controller.send(:current_active_admin_user).should == nil
    end

    it "should call the current_user_method when set" do
      user = mock
      namespace = controller.class.active_admin_config.namespace

      namespace.should_receive(:current_user_method).twice.
        and_return(:current_admin_user)

      controller.should_receive(:current_admin_user).and_return(user)

      controller.send(:current_active_admin_user).should == user
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
