require 'spec_helper'

describe ActiveAdmin::CanCanAdapter do

  describe "full integration" do

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ ActiveAdmin::Namespace.new(application, "Admin") }
    let(:resource){ namespace.register(Post) }

    let :mock_ability_class do
      Class.new do
        include CanCan::Ability

        def initialize(user)
          can :read, Post
          cannot :update, Post
        end

      end
    end

    it "should initialize the ability stored in the namespace configuration" do
      namespace.authorization_adapter = ActiveAdmin::CanCanAdapter
      namespace.cancan_ability_class = mock_ability_class

      auth = namespace.authorization_adapter.new(resource, mock)

      auth.authorized?(:read, Post).should == true
      auth.authorized?(:update, Post).should == false
    end

  end

end
