require 'spec_helper'

describe ActiveAdmin::PunditAdapter do

  describe "full integration" do

    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { ActiveAdmin::Namespace.new(application, "Admin") }
    let(:resource) { namespace.register(Post) }
    let(:auth) { namespace.authorization_adapter.new(resource, double) }

    before do
      namespace.authorization_adapter = ActiveAdmin::PunditAdapter
    end

    it "should initialize the ability stored in the namespace configuration" do
      expect(auth.authorized?(:read, Post)).to eq true
      expect(auth.authorized?(:update, Post)).to eq false
    end

    it "should scope the collection" do
      class RSpec::Mocks::MockPolicy < ApplicationPolicy
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
  end

end
