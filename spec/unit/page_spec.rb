# encoding: utf-8

require 'spec_helper' 
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Page do

    it_should_behave_like "ActiveAdmin::Config"
    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= namespace.register_page("Chocolate I lØve You!", options)
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        config.controller_name.should == "Admin::ChocolateILoveYouController"
      end
      context "when non namespaced controller" do
        let(:namespace){ ActiveAdmin::Namespace.new(application, :root) }
        it "should return a non namespaced controller name" do
          config.controller_name.should == "ChocolateILoveYouController"
        end
      end
    end

    describe "#resource_name" do
      it "returns the name" do
        config.resource_name.should == "Chocolate I lØve You!"
      end

      it "returns the singular, lowercase name" do
        config.resource_name.singular.should == "chocolate i lØve you!"
      end
    end

    describe "#plural_resource_label" do
      it "returns the singular name" do
        config.plural_resource_label.should == "Chocolate I lØve You!"
      end
    end

    describe "#underscored_resource_name" do
      it "returns the resource name underscored" do
        config.underscored_resource_name.should == "chocolate_i_love_you"
      end
    end

    describe "#camelized_resource_name" do
      it "returns the resource name camel case" do
        config.camelized_resource_name.should == "ChocolateILoveYou"
      end
    end

    it "should not belong_to anything" do
      config.belongs_to?.should == false
    end

    it "should not have any action_items" do
      config.action_items?.should == false
    end

    it "should not have any sidebar_sections" do
      config.sidebar_sections?.should == false
    end

  end
end
