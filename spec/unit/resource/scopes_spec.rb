require 'spec_helper'

module ActiveAdmin
  describe Resource, "Scopes" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "adding a scope" do

      it "should add a scope" do
        config.scope :published
        config.scopes.first.should be_a(ActiveAdmin::Scope)
        config.scopes.first.name.should == "Published"
      end

      it "should retrive a scope by its id" do
        config.scope :published
        config.get_scope_by_id(:published).name.should == "Published"
      end

      it "should not add a scope with the same name twice" do
        config.scope :published
        config.scope :published
        config.scopes.size.should == 1
      end

      it "should update a scope with the same id" do
        config.scope :published
        config.scopes.first.scope_block.should be_nil
        config.scope(:published){  }
        config.scopes.first.scope_block.should_not be_nil
      end

    end
  end
end
