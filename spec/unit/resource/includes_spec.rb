require 'rails_helper'

module ActiveAdmin
  RSpec.describe Resource, "Includes" do
    describe "#includes" do
      let(:application) { ActiveAdmin::Application.new }
      let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
      let(:resource_config) { ActiveAdmin::Resource.new namespace, Post }
      let(:dsl) { ActiveAdmin::ResourceDSL.new(resource_config) }

      it "should register the includes in the config" do
        dsl.run_registration_block do
          includes :taggings, :author
        end
        expect(resource_config.includes.size).to eq(2)
      end
    end
  end
end
