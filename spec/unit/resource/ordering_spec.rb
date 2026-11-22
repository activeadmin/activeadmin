# frozen_string_literal: true
require "rails_helper"

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
        my_order_clause = Class.new(ActiveAdmin::OrderClause)
        dsl.run_registration_block do
          config.order_clause = my_order_clause
        end
        expect(resource_config.order_clause).to eq(my_order_clause)
        expect(application.order_clause).to eq(ActiveAdmin::OrderClause)
      end
    end
  end
end
