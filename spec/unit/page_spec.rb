require 'rails_helper'
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  RSpec.describe Page do

    it_should_behave_like "ActiveAdmin::Resource"
    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }
    let(:page_name) { "Chocolate I lØve You!" }

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
        if RUBY_VERSION >= '2.4.0'
          expect(config.resource_name.singular).to eq "chocolate i løve you!"
        else
          expect(config.resource_name.singular).to eq "chocolate i lØve you!"
        end
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

    context "with belongs to config" do
      let!(:post_config) { namespace.register Post }
      let!(:page_config) {
        namespace.register_page page_name do
          belongs_to :post
        end
      }

      it "configures page with belongs_to" do
        expect(page_config.belongs_to?).to be true
      end

      it "sets navigation menu to parent" do
        expect(page_config.navigation_menu_name).to eq :post
      end

      it "builds a belongs_to relationship" do
        belongs_to = page_config.belongs_to_config

        expect(belongs_to.target).to eq(post_config)
        expect(belongs_to.owner).to eq(page_config)
        expect(belongs_to.optional?).to be_falsy
      end

      it "forwards belongs_to call to controller" do
        options = { optional: true }
        expect(page_config.controller).to receive(:belongs_to).with(:post, options)
        page_config.belongs_to :post, options
      end
    end # context "with belongs to config" do

    context "with optional belongs to config" do
      let!(:post_config) { namespace.register Post }
      let!(:page_config) {
        namespace.register_page page_name do
          belongs_to :post, optional: true
        end
      }

      it "does not override default navigation menu" do
        expect(page_config.navigation_menu_name).to eq(:default)
      end
    end # context "with optional belongs to config" do

    it "has no belongs_to by default" do
      expect(config.belongs_to?).to be_falsy
    end
  end
end
