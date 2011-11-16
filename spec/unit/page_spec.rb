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
  end
end
