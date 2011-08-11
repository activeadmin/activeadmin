require 'spec_helper'

describe ActiveAdmin::ScopeChain do

  include ActiveAdmin::ScopeChain

  describe "#scope_chain" do
    let(:relation) { mock }

    context "when Scope has a scope method" do
      let(:scope) { ActiveAdmin::Scope.new :published }

      it "should call the method on the relation and return it" do
        relation.should_receive(:published).and_return(:scoped_relation)
        scope_chain(scope, relation).should == :scoped_relation
      end
    end

    context "when Scope has the scope method method ':all'" do
      let(:scope) { ActiveAdmin::Scope.new :all }

      it "should return the relation" do
        scope_chain(scope, relation).should == relation
      end
    end

    context "when Scope has a name and a scope block" do
      let(:scope) { ActiveAdmin::Scope.new("My Scope"){|s| :scoped_relation } }

      it "should instance_exec the block and return it" do
        scope_chain(scope, relation).should == :scoped_relation
      end
    end
  end
end

