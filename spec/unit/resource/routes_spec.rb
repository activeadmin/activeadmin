require 'rails_helper' 

module ActiveAdmin
  describe Resource::Routes do
    before { load_defaults! }

    describe "route names" do
      context "when in the admin namespace" do
        let!(:config)  { ActiveAdmin.register Category }
        let(:category) { Category.new { |c| c.id = 123 } }

        it "should return the route prefix" do
          expect(config.route_prefix).to eq 'admin'
        end

        it "should return the route collection path" do
          expect(config.route_collection_path).to eq '/admin/categories'
        end

        it "should return the route instance path" do
          expect(config.route_instance_path(category)).to eq '/admin/categories/123'
        end
      end

      context "when in the root namespace" do
        let!(:config) { ActiveAdmin.register Category, namespace: false }
        it "should have a nil route_prefix" do
          expect(config.route_prefix).to eq nil
        end

        it "should generate a correct route" do
          reload_routes!
          expect(config.route_collection_path).to eq "/categories"
        end
      end

      context "when registering a plural resource" do
        class ::News; def self.has_many(*); end end
        let!(:config) { ActiveAdmin.register News }
        before{ reload_routes! }

        it "should return the plural route with _index" do
          expect(config.route_collection_path).to eq "/admin/news"
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
          expect(config.route_collection_path(category_id: 1)).to eq "/admin/categories/1/posts"
        end

        it "should nest the instance path" do
          expect(config.route_instance_path(post)).to eq "/admin/categories/1/posts/3"
        end
      end
    end
  end
end
