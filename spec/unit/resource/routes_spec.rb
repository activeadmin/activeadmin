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

      context "when the resource belongs to another resource" do
        before do
          namespace.register User
        end

        it "should nest the collection path" do
          config = namespace.register Post do
            belongs_to :user
          end

          config.route_collection_path(user_id: 1).should == "/admin/users/1/posts"
        end
      end
    end
  end
end
