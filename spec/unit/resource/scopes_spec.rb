require 'rails_helper'

module ActiveAdmin
  RSpec.describe Resource, "Scopes" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "adding a scope" do

      it "should add a scope" do
        config.scope :published
        expect(config.scopes.first).to be_a(ActiveAdmin::Scope)
        expect(config.scopes.first.name).to eq "Published"
      end

      it "should retrive a scope by its id" do
        config.scope :published
        expect(config.get_scope_by_id(:published).name).to eq "Published"
      end

      it "should retrieve a string scope with spaces by its id without conflicts" do
        aspace_1 = config.scope "a space"
        aspace_2 = config.scope "as pace"
        expect(config.get_scope_by_id(aspace_1.id).name).to eq "a space"
        expect(config.get_scope_by_id(aspace_2.id).name).to eq "as pace"
      end

      it "should not add a scope with the same name twice" do
        config.scope :published
        config.scope :published
        expect(config.scopes.size).to eq 1
      end

      it "should update a scope with the same id" do
        config.scope :published
        expect(config.scopes.first.scope_block).to eq nil
        config.scope(:published){ }
        expect(config.scopes.first.scope_block).to_not eq nil
      end

    end
  end
end
