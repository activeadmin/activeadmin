require 'spec_helper' 
require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Page do

    it_should_behave_like "ActiveAdmin::Config"
    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Page.new(namespace, "Status", options)
    end

    describe "controller name" do
      it "should return a namespaced controller name" do
        config.controller_name.should == "Admin::StatusController"
      end
      context "when non namespaced controller" do
        let(:namespace){ ActiveAdmin::Namespace.new(application, :root) }
        it "should return a non namespaced controller name" do
          config.controller_name.should == "StatusController"
        end
      end
    end

    describe "#resource_name" do
      it "returns the name" do
        config.resource_name.should == "Status"
      end
    end

    describe "#plural_resource_name" do
      it "returns the singular name" do
        config.plural_resource_name.should == "Status"
      end
    end

    describe "#underscored_resource_name" do
      it "returns the underscored name" do
        config.underscored_resource_name.should == "status"
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
