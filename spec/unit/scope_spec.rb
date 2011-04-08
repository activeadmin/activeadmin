require 'spec_helper'

describe ActiveAdmin::Scope do

  describe "creating a scope" do
    subject{ scope }

    context "when just a scope method" do
      let(:scope)        { ActiveAdmin::Scope.new :published }
      its(:name)         { should == "Published"}
      its(:id)           { should == "published"}
      its(:scope_method) { should == :published }
    end

    context "when a name and scope method" do
      let(:scope)        { ActiveAdmin::Scope.new "My Scope", :scope_method }
      its(:name)         { should == "My Scope"}
      its(:id)           { should == "my_scope"}
      its(:scope_method) { should == :scope_method }
    end

    context "when a name and scope block" do
      let(:scope)        { ActiveAdmin::Scope.new("My Scope"){|s| s } }
      its(:name)         { should == "My Scope"}
      its(:id)           { should == "my_scope"}
      its(:scope_method) { should == nil }
      its(:scope_block)  { should be_a(Proc)}
    end
  end

end
