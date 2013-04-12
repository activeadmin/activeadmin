require 'spec_helper' 
#require File.expand_path('config_shared_examples', File.dirname(__FILE__))

module ActiveAdmin
  describe Resource::Routes do
    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "route names" do
      it "should return the route prefix" do
        config.route_prefix.should == "admin"
      end
      it "should return the route collection path" do
        config.route_collection_path.should == "/admin/categories"
      end

      context "when in the root namespace" do
        let(:config){ application.register Category, :namespace => false}
        it "should have a nil route_prefix" do
          config.route_prefix.should == nil
        end

        it "should generate a correct route" do
          config
          reload_routes!
          config.route_collection_path.should == "/categories"
        end
      end

      context "when registering a plural resource" do
        class ::News; def self.has_many(*); end end

        it "should return the plurali route with _index" do
          config = application.register News
          reload_routes!
          config.route_collection_path.should == "/admin/news"
        end
      end
    end
  end
end
