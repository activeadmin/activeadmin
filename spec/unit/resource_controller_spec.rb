# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::ResourceController, type: :controller do
  let(:controller) { Admin::PostsController.new }

  describe "callbacks" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Post) do
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
            private

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
    end

    describe "performing create" do
      let(:resource) { double("Resource", save: true) }

      before do
        expect(resource).to receive(:save)
      end

      it "should call the before create callback" do
        expect(controller).to receive(:call_before_create).with(resource)
        controller.send :create_resource, resource
      end

      it "should call the before save callback" do
        expect(controller).to receive(:call_before_save).with(resource)
        controller.send :create_resource, resource
      end

      it "should call the after save callback" do
        expect(controller).to receive(:call_after_save).with(resource)
        controller.send :create_resource, resource
      end

      it "should call the after create callback" do
        expect(controller).to receive(:call_after_create).with(resource)
        controller.send :create_resource, resource
      end
    end

    describe "performing update" do
      let(:resource) { double("Resource", :attributes= => true, save: true) }
      let(:attributes) { [{}] }

      before do
        expect(resource).to receive(:attributes=).with(attributes[0])
        expect(resource).to receive(:save)
      end

      it "should call the before update callback" do
        expect(controller).to receive(:call_before_update).with(resource)
        controller.send :update_resource, resource, attributes
      end

      it "should call the before save callback" do
        expect(controller).to receive(:call_before_save).with(resource)
        controller.send :update_resource, resource, attributes
      end

      it "should call the after save callback" do
        expect(controller).to receive(:call_after_save).with(resource)
        controller.send :update_resource, resource, attributes
      end

      it "should call the after create callback" do
        expect(controller).to receive(:call_after_update).with(resource)
        controller.send :update_resource, resource, attributes
      end
    end

    describe "performing destroy" do
      let(:resource) { double("Resource", destroy: true) }

      before do
        expect(resource).to receive(:destroy)
      end

      it "should call the before destroy callback" do
        expect(controller).to receive(:call_before_destroy).with(resource)
        controller.send :destroy_resource, resource
      end

      it "should call the after destroy callback" do
        expect(controller).to receive(:call_after_destroy).with(resource)
        controller.send :destroy_resource, resource
      end
    end
  end

  describe "action methods" do
    around do |example|
      with_resources_during(example) do
        load_resources { ActiveAdmin.register Post }
      end
    end

    it "should have actual action methods" do
      controller.class.clear_action_methods! # make controller recalculate :action_methods on the next call
      expect(controller.action_methods.sort).to eq ["batch_action", "create", "destroy", "edit", "index", "new", "show", "update"]
    end
  end
end

RSpec.describe "A specific resource controller", type: :controller do
  around do |example|
    with_resources_during(example) do
      ActiveAdmin.register Post
      @controller = Admin::PostsController.new
    end
  end

  describe "authenticating the user" do
    it "should do nothing when no authentication_method set" do
      namespace = controller.class.active_admin_config.namespace
      expect(namespace).to receive(:authentication_method).once.and_return(nil)

      controller.send(:authenticate_active_admin_user)
    end

    it "should call the authentication_method when set" do
      namespace = controller.class.active_admin_config.namespace

      expect(namespace).to receive(:authentication_method).twice.
        and_return(:authenticate_admin_user!)

      expect(controller).to receive(:authenticate_admin_user!).and_return(true)

      controller.send(:authenticate_active_admin_user)
    end
  end

  describe "retrieving the current user" do
    it "should return nil when no current_user_method set" do
      namespace = controller.class.active_admin_config.namespace
      expect(namespace).to receive(:current_user_method).once.and_return(nil)

      expect(controller.send(:current_active_admin_user)).to eq nil
    end

    it "should call the current_user_method when set" do
      user = double
      namespace = controller.class.active_admin_config.namespace

      expect(namespace).to receive(:current_user_method).twice.
        and_return(:current_admin_user)

      expect(controller).to receive(:current_admin_user).and_return(user)

      expect(controller.send(:current_active_admin_user)).to eq user
    end
  end

  describe "retrieving the resource" do
    let(:post) { Post.new title: "An incledibly unique Post Title" }
    let(:http_params) { { id: "1" } }

    before do
      allow(Post).to receive(:find).and_return(post)
      controller.class_eval { public :resource }
      allow(controller).to receive(:params).and_return(ActionController::Parameters.new(http_params))
    end

    subject { controller.resource }

    it "returns a Post" do
      expect(subject).to be_kind_of(Post)
    end

    context "with a decorator" do
      let(:config) { controller.class.active_admin_config }

      context "with a Draper decorator" do
        before { config.decorator_class_name = "::PostDecorator" }

        it "returns a PostDecorator" do
          expect(subject).to be_kind_of(PostDecorator)
        end

        it "returns a PostDecorator that wraps the post" do
          expect(subject.title).to eq post.title
        end
      end

      context "with a PORO decorator" do
        before { config.decorator_class_name = "::PostPoroDecorator" }

        it "returns a PostDecorator" do
          expect(subject).to be_kind_of(PostPoroDecorator)
        end

        it "returns a PostDecorator that wraps the post" do
          expect(subject.title).to eq post.title
        end
      end
    end
  end

  describe "retrieving the resource collection" do
    let(:config) { controller.class.active_admin_config }
    before do
      Post.create!(title: "An incledibly unique Post Title")
      config.decorator_class_name = nil
      request = double "Request", format: "application/json"
      allow(controller).to receive(:params) { {} }
      allow(controller).to receive(:request) { request }
    end

    subject { controller.send :collection }

    it {
      is_expected.to be_a ActiveRecord::Relation
    }

    it "returns a collection of posts" do
      expect(subject.first).to be_kind_of(Post)
    end

    context "with a decorator" do
      before { config.decorator_class_name = "PostDecorator" }

      it "returns a collection decorator using PostDecorator" do
        expect(subject).to be_a Draper::CollectionDecorator
        expect(subject.decorator_class).to eq PostDecorator
      end

      it "returns a collection decorator that wraps the post" do
        expect(subject.first.title).to eq Post.first.title
      end
    end
  end

  describe "performing batch_action" do
    let(:batch_action) { ActiveAdmin::BatchAction.new *batch_action_args, &batch_action_block }
    let(:batch_action_block) { proc { self.instance_variable_set :@block_context, self.class } }
    let(:params) { ActionController::Parameters.new(http_params) }

    before do
      allow(controller.class.active_admin_config).to receive(:batch_actions).and_return([batch_action])
      allow(controller).to receive(:params) { params }
    end

    describe "when params batch_action matches existing BatchAction" do
      let(:batch_action_args) { [:flag, "Flag"] }

      let(:http_params) do
        { batch_action: "flag", collection_selection: ["1"] }
      end

      it "should call the block with args" do
        expect(controller).to receive(:instance_exec).with(["1"], {})
        controller.batch_action
      end

      it "should call the block in controller scope" do
        controller.batch_action
        expect(controller.instance_variable_get(:@block_context)).to eq Admin::PostsController
      end
    end

    describe "when params batch_action matches existing BatchAction and form inputs defined" do
      let(:batch_action_args) { [:flag, "Flag", { form: { type: ["a", "b"] } }] }

      let(:http_params) do
        { batch_action: "flag", collection_selection: ["1"], batch_action_inputs: '{ "type": "a", "bogus": "param" }' }
      end

      it "should filter permitted params" do
        expect(controller).to receive(:instance_exec).with(["1"], { "type" => "a" })
        controller.batch_action
      end
    end

    describe "when params batch_action doesn't match a BatchAction" do
      let(:batch_action_args) { [:flag, "Flag"] }

      let(:http_params) do
        { batch_action: "derp", collection_selection: ["1"] }
      end

      it "should raise an error" do
        expect do
          controller.batch_action
        end.to raise_error("Couldn't find batch action \"derp\"")
      end
    end

    describe "when params batch_action is blank" do
      let(:batch_action_args) { [:flag, "Flag"] }

      let(:http_params) do
        { collection_selection: ["1"] }
      end

      it "should raise an error" do
        expect do
          controller.batch_action
        end.to raise_error("Couldn't find batch action \"\"")
      end
    end
  end
end
