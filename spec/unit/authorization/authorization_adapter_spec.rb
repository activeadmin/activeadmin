require 'spec_helper'

describe ActiveAdmin::AuthorizationAdapter do

  let(:adapter) { ActiveAdmin::AuthorizationAdapter.new(stub, stub) }

  describe "#authorized?" do

    it "should always return true" do
      adapter.authorized?(:read, "Resource").should == true
    end

  end

  describe "#scope_collection" do

    it "should return the collection unscoped" do
      collection = stub
      adapter.scope_collection(collection, ActiveAdmin::Auth::READ).should == collection
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

    let(:adapter) { auth_class.new(stub, stub) }

    it "should match against a class" do
      adapter.authorized?(:read, String).should == true
    end

    it 'should match against an instance' do
      adapter.authorized?(:read, "String").should == true
    end

    it 'should not match a different class' do
      adapter.authorized?(:read, Hash).should == false
    end

    it 'should not match a different instance' do
      adapter.authorized?(:read, {}).should == false
    end

  end

end
