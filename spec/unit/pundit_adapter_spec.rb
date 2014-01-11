require 'spec_helper'

class MockPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?  ; false   ; end
  def show?   ; true    ; end
  def new?    ; create? ; end
  def create? ; false   ; end
  def edit?   ; update? ; end
  def update? ; false   ; end
  def destroy?; false   ; end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end

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
      class PostPolicy < MockPolicy
      end

      expect(auth.authorized?(:update, Post)).to eq false
      expect(auth.authorized?(:read, Post.new)).to eq true
    end

    it "should scope the collection" do
      class RSpec::Mocks::MockPolicy < MockPolicy
      end

      collection = double
      auth.scope_collection(collection)
      expect(collection).to eq collection
    end
  end

end
