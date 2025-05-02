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
    end

    it "should initialize the policy stored in the namespace configuration" do
      expect(auth.authorized?(:read, Post)).to eq true
      expect(auth.authorized?(:update, Post)).to eq false
    end

    it "should treat :new ability the same as :create" do
      expect(auth.authorized?(:new, Post)).to eq true
      expect(auth.authorized?(:create, Post)).to eq true
    end

    it "should scope the collection" do
      collection = double
      expect(collection).to receive(:accessible_by).with(auth.action_policy, :read)
      auth.scope_collection(collection, :read)
    end

    context "when ActionPolicy namespace provided" do
      before do
        allow(ActiveAdmin.application).to receive(:action_policy_namespace).and_return :foobar
      end

      it "looks for a namespaced policy" do
        expect(ActionPolicy).to receive(:lookup).with(Post).and_return(DefaultPolicy)
        auth.authorized?(:read, Post)
      end

      it "looks for a namespaced policy scope" do
        collection = double
        expect(ActionPolicy).to receive(:lookup).with(collection).and_return(DefaultPolicy)
        auth.scope_collection(collection, :read)
      end

      it "uses the resource when no subject given" do
        expect(ActionPolicy).to receive(:lookup).with(resource).and_return(DefaultPolicy)
        auth.authorized?(:index)
      end
    end

    context "when ActionPolicy is unable to find policy" do
      let(:record) { double }

      subject(:policy) { auth.retrieve_policy(record) }

      before do
        allow(ActiveAdmin.application).to receive(:action_policy_default_policy).and_return "DefaultPolicy"
      end

      it("should return default policy instance") { is_expected.to be_instance_of(DefaultPolicy) }

      context "and default policy doesn't exist" do
        let(:default_policy_klass_name) { nil }

        it "raises the error" do
          expect { subject }.to raise_error ActionPolicy::NotFound
        end
      end
    end
  end
end 