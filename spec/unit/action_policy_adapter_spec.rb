# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::ActionPolicyAdapter do
  describe "full integration" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { ActiveAdmin::Namespace.new(application, "Admin") }
    let(:resource) { namespace.register(Post) }
    let(:user) { User.new }
    let(:auth) { namespace.authorization_adapter.new(resource, user) }

    before do
      namespace.authorization_adapter = ActiveAdmin::ActionPolicyAdapter
      ActiveAdmin.application.action_policy_default_policy = ActionPolicy::ApplicationPolicy
      ActiveAdmin.application.action_policy_namespace = "ActionPolicy"
    end

    it "should initialize the policy stored in the namespace configuration" do
      expect(auth.authorized?(:read, Post)).to eq false
      expect(auth.authorized?(:update, Post)).to eq false
    end

    it "should allow differentiating between new and create" do
      expect(auth.authorized?(:new, Post)).to eq true
      expect(auth.authorized?(ActiveAdmin::Auth::NEW, Post)).to eq true

      announcement_category = Category.new(name: "Announcements")
      announcement_post = Post.new(title: "Big announcement", category: announcement_category)
      expect(auth.authorized?(:create, announcement_post)).to eq false
      expect(auth.authorized?(ActiveAdmin::Auth::CREATE, announcement_post)).to eq false
    end

    it "should scope the collection" do
      collection = Post.all
      scoped = auth.scope_collection(collection, :read)

      expect(scoped).to eq(collection)
    end

    context "when ActionPolicy namespace provided" do
      before do
        allow(ActiveAdmin.application).to receive(:action_policy_namespace).and_return "ActionPolicy"
      end

      it "looks for a namespaced policy" do
        expect(ActionPolicy::PostPolicy).to receive(:new).and_call_original
        auth.authorized?(:read, Post)
      end
    end

    context "when ActionPolicy is unable to find policy" do
      let(:record) { double("record") }

      subject(:policy) { auth.retrieve_policy(record) }

      before do
        allow(ActiveAdmin.application).to receive(:action_policy_default_policy).and_return ActionPolicy::ApplicationPolicy
        allow(ActionPolicy).to receive(:lookup).and_raise(ActionPolicy::NotFound)
      end

      it("should return default policy instance") { is_expected.to be_instance_of(ActionPolicy::ApplicationPolicy) }

      context "and default policy doesn't exist" do
        before do
          allow(ActiveAdmin.application).to receive(:action_policy_default_policy).and_return nil
        end

        it "raises the error" do
          expect { subject }.to raise_error ActionPolicy::NotFound
        end
      end
    end
  end
end
