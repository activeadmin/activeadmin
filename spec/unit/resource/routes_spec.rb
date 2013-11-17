require 'spec_helper' 

module ActiveAdmin
  describe Resource::Routes do
    before { load_defaults! }

    describe "route names" do
      context "when in the admin namespace" do
        let!(:config)  { ActiveAdmin.register Category }
        let(:category) { Category.new { |c| c.id = 123 } }

        it "should return the route prefix" do
          config.route_prefix.should eq 'admin'
        end

        it "should return the route collection path" do
          config.route_collection_path.should eq '/admin/categories'
        end

        it "should return the route instance path" do
          config.route_instance_path(category).should eq '/admin/categories/123'
        end
      end

      context "when in the root namespace" do
        let!(:config) { ActiveAdmin.register Category, :namespace => false }
        it "should have a nil route_prefix" do
          config.route_prefix.should be_nil
        end

        it "should generate a correct route" do
          reload_routes!
          config.route_collection_path.should == "/categories"
        end
      end

      context "when registering a plural resource" do
        class ::News; def self.has_many(*); end end
        let!(:config) { ActiveAdmin.register News }
        before{ reload_routes! }

        it "should return the plural route with _index" do
          config.route_collection_path.should == "/admin/news"
        end
      end

      context "when the resource belongs to another resource" do
        let! :config do
          ActiveAdmin.register Post do
            belongs_to :category
          end
        end

        let :post do
          Post.new do |p|
            p.id = 3
            p.category = Category.new{ |c| c.id = 1 }
          end
        end

        before{ reload_routes! }

        it "should nest the collection path" do
          config.route_collection_path(category_id: 1).should == "/admin/categories/1/posts"
        end

        it "should nest the instance path" do
          config.route_instance_path(post).should == "/admin/categories/1/posts/3"
        end
      end
    end
  end
end
