# frozen_string_literal: true
require "rails_helper"

class DefaultPolicy < ApplicationPolicy
  def respond_to_missing?(method, include_private = false)
    method.to_s[0...3] == "foo" || super
  end

  def method_missing(method, *args, &block)
    method.to_s[4...7] == "yes" if method.to_s[0...3] == "foo"
  end

  class Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end

RSpec.describe ActiveAdmin::PunditAdapter do
  describe "full integration" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { ActiveAdmin::Namespace.new(application, "Admin") }
    let(:resource) { namespace.register(Post) }
    let(:user) { User.new }
    let(:auth) { namespace.authorization_adapter.new(resource, user) }
    let(:default_policy_klass) { DefaultPolicy }
    let(:default_policy_klass_name) { "DefaultPolicy" }

    before do
      namespace.authorization_adapter = ActiveAdmin::PunditAdapter
    end

    it "should initialize the ability stored in the namespace configuration" do
      expect(auth.authorized?(:read, Post)).to eq true
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
      class RSpec::Mocks::DoublePolicy < ApplicationPolicy
        class Scope < Struct.new(:user, :scope)
          def resolve
            scope
          end
        end
      end

      collection = double
      auth.scope_collection(collection, :read)
      expect(collection).to eq collection
    end

    it "works well with method_missing" do
      allow(auth).to receive(:retrieve_policy).and_return(DefaultPolicy.new(double, double))
      expect(auth.authorized?(:foo_no)).to eq false
      expect(auth.authorized?(:foo_yes)).to eq true
      expect(auth.authorized?(:bar_yes)).to eq false
    end

    context "when Pundit namespace provided" do
      before do
        allow(ActiveAdmin.application).to receive(:pundit_policy_namespace).and_return :foobar
      end

      it "looks for a namespaced policy" do
        expect(Pundit).to receive(:policy).with(anything, [:foobar, Post]).and_return(DefaultPolicy.new(double, double))
        auth.authorized?(:read, Post)
      end

      it "looks for a namespaced policy scope" do
        collection = double
        expect(Pundit).to receive(:policy_scope!).with(anything, [:foobar, collection]).and_return(DefaultPolicy::Scope.new(double, double))
        auth.scope_collection(collection, :read)
      end

      it "uses the resource when no subject given" do
        expect(Pundit).to receive(:policy).with(anything, [:foobar, resource]).and_return(DefaultPolicy::Scope.new(double, double))
        auth.authorized?(:index)
      end
    end

    it "uses the resource when no subject given" do
      expect(Pundit).to receive(:policy).with(anything, resource).and_return(DefaultPolicy::Scope.new(double, double))
      auth.authorized?(:index)
    end

    context "when model name contains policy namespace name" do
      include_context "capture stderr"

      before do
        allow(ActiveAdmin.application).to receive(:pundit_policy_namespace).and_return :pub
        namespace.register(Publisher)
        ActiveAdmin.deprecator.behavior = :stderr
      end

      after do
        ActiveAdmin.deprecator.behavior = :raise
      end

      it "looks for a namespaced policy" do
        expect(Pundit).to receive(:policy).with(anything, [:pub, Publisher]).and_return(DefaultPolicy.new(double, double))
        auth.authorized?(:read, Publisher)
      end

      it "fallbacks to the policy without namespace" do
        expect(Pundit).to receive(:policy).with(anything, [:pub, Publisher]).and_return(nil)
        expect(Pundit).to receive(:policy).with(anything, Publisher).and_return(DefaultPolicy.new(double, double))

        auth.authorized?(:read, Publisher)

        expect($stderr.string).to include("ActiveAdmin was unable to find policy Pub::DefaultPolicy. DefaultPolicy will be used instead.")
      end
    end

    context "when Pundit is unable to find policy scope" do
      let(:collection) { double("collection", to_sym: :collection) }
      subject(:scope) { auth.scope_collection(collection, :read) }

      before do
        allow(ActiveAdmin.application).to receive(:pundit_default_policy).and_return default_policy_klass_name
        allow(Pundit).to receive(:policy_scope!) { raise Pundit::NotDefinedError.new }
      end

      it("should return default policy's scope if defined") { is_expected.to eq(collection) }

      context "and default policy doesn't exist" do
        let(:default_policy_klass_name) { nil }

        it "raises the error" do
          expect { subject }.to raise_error Pundit::NotDefinedError
        end
      end
    end

    context "when Pundit is unable to find policy" do
      let(:record) { double }

      subject(:policy) { auth.retrieve_policy(record) }

      before do
        allow(ActiveAdmin.application).to receive(:pundit_default_policy).and_return default_policy_klass_name
        allow(Pundit).to receive(:policy) { nil }
      end

      it("should return default policy instance") { is_expected.to be_instance_of(default_policy_klass) }

      context "and default policy doesn't exist" do
        let(:default_policy_klass_name) { nil }

        it "raises the error" do
          expect { subject }.to raise_error Pundit::NotDefinedError
        end
      end
    end

    context "when retrieve_policy is given a page and namespace is :active_admin" do
      let(:page) { namespace.register_page "Dashboard" }

      subject(:policy) { auth.retrieve_policy(page) }

      before do
        allow(ActiveAdmin.application).to receive(:pundit_policy_namespace).and_return :active_admin
      end

      it("should return page policy instance") { is_expected.to be_instance_of(ActiveAdmin::PagePolicy) }
    end
  end
end
