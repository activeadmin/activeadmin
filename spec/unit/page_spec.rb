# encoding: utf-8

require 'rails_helper'
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Page do

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

    it "should not have any action_items" do
      expect(config.action_items?).to eq false
    end

    it "should not have any sidebar_sections" do
      expect(config.sidebar_sections?).to eq false
    end

    context "with belongs to config" do
      let!(:post_registration) { namespace.register Post }
      let!(:page_registration) {
        namespace.register_page page_name do
          belongs_to :post
        end
      }

      subject { page_registration }

      its(:belongs_to?)          { should be_true }
      its(:navigation_menu_name) { should eq(:post) }

      describe "#belongs_to_config" do
        subject { page_registration.belongs_to_config }

        it              { should_not be_nil }
        its(:target)    { should eq(post_registration) }
        its(:owner)     { should eq(page_registration) }
        its(:optional?) { should be_false }
      end

      it "forwards belongs_to call to controller" do
        options = { :optional => true }
        subject.controller.should_receive(:belongs_to).with(:post, options)
        subject.belongs_to :post, options
      end
    end # context "with belongs to config" do

    context "with optional belongs to config" do
      let!(:post_registration) { namespace.register Post }
      let!(:page_registration) {
        namespace.register_page page_name do
          belongs_to :post, :optional => true
        end
      }

      subject { page_registration }

      its(:navigation_menu_name) { should eq(:default) }

      describe "#belongs_to_config" do
        subject { page_registration.belongs_to_config }

        it              { should_not be_nil }
        its(:target)    { should eq(post_registration) }
        its(:owner)     { should eq(page_registration) }
        its(:optional?) { should be_true }
      end
    end # context "with optional belongs to config" do

    context "without belongs to config" do
      subject { config }

      its(:belongs_to?)       { should be_false }
      its(:belongs_to_config) { should be_nil }
    end # context "without belongs to config" do
  end
end
