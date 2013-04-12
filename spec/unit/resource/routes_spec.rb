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

      it "should return the route instance path" do
        category = Category.new { |c| c.id = 123 }
        config.route_instance_path(category).should == "/admin/categories/123"
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
        let(:config) do
          config = ActiveAdmin.register Post do
            belongs_to :category
          end

          reload_routes!

          config
        end

        it "should nest the collection path" do
          config.route_collection_path(category_id: 1).should == "/admin/categories/1/posts"
        end

        it "should nest the instance path" do
          post = Post.new { |p| p.id = 3; p.category = Category.new { |c| c.id = 1 } }
          config.route_instance_path(post).should == "/admin/categories/1/posts/3"
        end
      end
    end
  end
end
