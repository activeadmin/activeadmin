require 'rails_helper'

RSpec.describe ActiveAdmin::CanCanAdapter do
  describe "full integration" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { ActiveAdmin::Namespace.new(application, "Admin") }
    let(:resource) { namespace.register(Post) }

    let :ability_class do
      Class.new do
        include CanCan::Ability

        def initialize(user)
          can :read, Post
          cannot :update, Post
        end
      end
    end

    let(:auth) { namespace.authorization_adapter.new(resource, double) }

    before do
      namespace.authorization_adapter = ActiveAdmin::CanCanAdapter
      namespace.cancan_ability_class = ability_class
    end

    it "should initialize the ability stored in the namespace configuration" do
      expect(auth.authorized?(:read, Post)).to eq true
      expect(auth.authorized?(:update, Post)).to eq false
    end

    it "should scope the collection with accessible_by" do
      collection = double
      expect(collection).to receive(:accessible_by).with(auth.cancan_ability, :edit)
      auth.scope_collection(collection, :edit)
    end
  end
end
