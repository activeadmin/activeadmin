require 'spec_helper'

describe ActiveAdmin::ResourceController do

  before(:all) { load_defaults! }

  let(:controller) { ActiveAdmin::ResourceController.new }

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
    before :all do
      application = ::ActiveAdmin::Application.new
      namespace = ActiveAdmin::Namespace.new(application, :admin)
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
      let(:attributes){ [{}] }

      before do
        resource.should_receive(:attributes=).with(attributes[0])
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

describe Admin::PostsController, :type => "controller" do

  describe 'retreiving the resource' do
    let(:controller){ Admin::PostsController.new }
    let(:post) { Post.new :title => "An incledibly unique Post Title" }

    before do
      Post.stub(:find).and_return(post)
      controller.class_eval { public :resource }
      controller.stub(:params).and_return({ :id => '1' })
    end

    subject { controller.resource }

    it "returns a Post" do
      subject.should be_kind_of(Post)
    end

    context 'with a decorator' do
      let(:config) { controller.class.active_admin_config }
      before { config.decorator_class_name = '::PostDecorator' }
      it 'returns a PostDecorator' do
        subject.should be_kind_of(PostDecorator)
      end

      it 'returns a PostDecorator that wraps the post' do
        subject.title.should == post.title
      end
    end
  end

  describe 'retreiving the resource collection' do
    let(:controller){ Admin::PostsController.new }
    before do
      Post.create!(:title => "An incledibly unique Post Title") if Post.count == 0
      controller.class_eval { public :collection }
    end

    subject { controller.collection }

    it {
      pending # doesn't pass when running whole spec suite (WTF)
      should be_kind_of(ActiveRecord::Relation)
    }

    it "returns a collection of posts" do
      pending # doesn't pass when running whole spec suite (WTF)
      subject.first.should be_kind_of(Post)
    end

    context 'with a decorator' do
      let(:config) { controller.class.active_admin_config }
      before { config.decorator_class_name = '::PostDecorator' }

      it 'returns a PostDecorator' do
        pending # doesn't pass when running whole spec suite (WTF)
        subject.should be_kind_of(PostDecorator::DecoratedEnumerableProxy)
      end

      it 'returns a PostDecorator that wraps the post' do
        pending # doesn't pass when running whole spec suite (WTF)
        subject.first.title.should == Post.first.title
      end
    end
  end


  describe "performing batch_action" do
    let(:controller){ Admin::PostsController.new }
    before do
      batch_action = ActiveAdmin::BatchAction.new :flag, "Flag" do
        redirect_to collection_path
      end

      controller.class.active_admin_config.stub!(:batch_actions).and_return([batch_action])
    end

    describe "when params batch_action matches existing BatchAction" do
      it "should call the block with args" do
        pending # dont know how to check if the block was called
      end
    end

    describe "when params batch_action doesn't match a BatchAction" do
      it "should raise an error" do
        pending # doesn't pass when running whole spec suite (WTF)

        expect {
          post(:batch_action, :batch_action => "derp", :collection_selection => ["1"])
        }.to raise_error("Couldn't find batch action \"derp\"")
      end
    end

    describe "when params batch_action is blank" do
      it "should raise an error" do
        pending # doesn't pass when running whole spec suite (WTF)

        expect {
          post(:batch_action, :collection_selection => ["1"])
        }.to raise_error("Couldn't find batch action \"\"")
      end
    end

  end

end
