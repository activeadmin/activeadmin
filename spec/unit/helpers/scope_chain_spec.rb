require 'spec_helper'

describe ActiveAdmin::ScopeChain do

  include ActiveAdmin::ScopeChain

  describe "#scope_chain" do
    let(:relation) { double }

    context "when Scope has a scope method" do
      let(:scope) { ActiveAdmin::Scope.new :published }

      it "should call the method on the relation and return it" do
        expect(relation).to receive(:published).and_return(:scoped_relation)
        expect(scope_chain(scope, relation)).to eq :scoped_relation
      end
    end

    context "when Scope has the scope method method ':all'" do
      let(:scope) { ActiveAdmin::Scope.new :all }

      it "should return the relation" do
        expect(scope_chain(scope, relation)).to eq relation
      end
    end

    context "when Scope has a name and a scope block" do
      let(:scope) { ActiveAdmin::Scope.new("My Scope"){|s| :scoped_relation } }

      it "should instance_exec the block and return it" do
        expect(scope_chain(scope, relation)).to eq :scoped_relation
      end
    end
  end
end

