require 'rails_helper'

RSpec.describe ActiveAdmin::AuthorizationAdapter do

  let(:adapter) { ActiveAdmin::AuthorizationAdapter.new(double, double) }

  describe "#authorized?" do

    it "should always return true" do
      expect(adapter.authorized?(:read, "Resource")).to eq true
    end

  end

  describe "#scope_collection" do

    it "should return the collection unscoped" do
      collection = double
      expect(adapter.scope_collection(collection, ActiveAdmin::Auth::READ)).to eq collection
    end

  end

  describe "using #normalized in a subclass" do

    let(:auth_class) do
      Class.new(ActiveAdmin::AuthorizationAdapter) do

        def authorized?(action, subject = nil)
          case subject
          when normalized(String)
            true
          else
            false
          end
        end

      end
    end

    let(:adapter) { auth_class.new(double, double) }

    it "should match against a class" do
      expect(adapter.authorized?(:read, String)).to eq true
    end

    it 'should match against an instance' do
      expect(adapter.authorized?(:read, "String")).to eq true
    end

    it 'should not match a different class' do
      expect(adapter.authorized?(:read, Hash)).to eq false
    end

    it 'should not match a different instance' do
      expect(adapter.authorized?(:read, {})).to eq false
    end

  end

end
