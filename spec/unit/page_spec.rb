# encoding: utf-8

require 'rails_helper'
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Page do

    it_should_behave_like "ActiveAdmin::Resource"
    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= namespace.register_page("Chocolate I lØve You!", options)
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        expect(config.controller_name).to eq "Admin::ChocolateILoveYouController"
      end
      context "when non namespaced controller" do
        let(:namespace){ ActiveAdmin::Namespace.new(application, :root) }
        it "should return a non namespaced controller name" do
          expect(config.controller_name).to eq "ChocolateILoveYouController"
        end
      end
    end

    describe "#resource_name" do
      it "returns the name" do
        expect(config.resource_name).to eq "Chocolate I lØve You!"
      end

      it "returns the singular, lowercase name" do
        expect(config.resource_name.singular).to eq "chocolate i lØve you!"
      end
    end

    describe "#plural_resource_label" do
      it "returns the singular name" do
        expect(config.plural_resource_label).to eq "Chocolate I lØve You!"
      end
    end

    describe "#underscored_resource_name" do
      it "returns the resource name underscored" do
        expect(config.underscored_resource_name).to eq "chocolate_i_love_you"
      end
    end

    describe "#camelized_resource_name" do
      it "returns the resource name camel case" do
        expect(config.camelized_resource_name).to eq "ChocolateILoveYou"
      end
    end

    describe "#namespace_name" do
      it "returns the name of the namespace" do
        expect(config.namespace_name).to eq "admin"
      end
    end

    it "should not belong_to anything" do
      expect(config.belongs_to?).to eq false
    end

    it "should not have any action_items" do
      expect(config.action_items?).to eq false
    end

    it "should not have any sidebar_sections" do
      expect(config.sidebar_sections?).to eq false
    end

  end
end
