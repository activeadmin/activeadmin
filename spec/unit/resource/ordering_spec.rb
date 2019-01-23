require 'rails_helper'

module ActiveAdmin
  RSpec.describe Resource, "Ordering" do
    describe "#order_by" do
      let(:application) { ActiveAdmin::Application.new }
      let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
      let(:resource_config) { ActiveAdmin::Resource.new namespace, Post }
      let(:dsl) { ActiveAdmin::ResourceDSL.new(resource_config) }

      it "should register the ordering in the config" do
        dsl.run_registration_block do
          order_by(:age, &:to_sql)
        end
        expect(resource_config.ordering.size).to eq(1)
      end

      it "should allow to setup custom ordering class" do
        MyOrderClause = Class.new(ActiveAdmin::OrderClause)
        dsl.run_registration_block do
          config.order_clause = MyOrderClause
        end
        expect(resource_config.order_clause).to eq(MyOrderClause)
        expect(application.order_clause).to eq(ActiveAdmin::OrderClause)
      end
    end
  end
end
