require 'rails_helper'

RSpec.describe ActiveAdmin::Resource::Routes do

  after do
    load_defaults!
    reload_routes!
  end

  let(:application) { ActiveAdmin.application }
  let(:namespace) { application.namespace(:admin) }

  context "when in the admin namespace" do
    let(:config) { namespace.resource_for('Category') }

    before do
      load_resources { ActiveAdmin.register Category }
    end

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

    after(:each) do
      application.namespace(:root).unload!
      application.namespaces.instance_variable_get(:@namespaces).delete(:root)
    end

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
    let(:config) { namespace.resource_for('Post') }

    let :post do
      Post.new do |p|
        p.id = 3
        p.category = Category.new{ |c| c.id = 1 }
      end
    end

    before do
      load_resources do
        ActiveAdmin.register Category
        ActiveAdmin.register(Post) { belongs_to :category }
      end
    end

    it "should nest the collection path" do
      expect(config.route_collection_path(category_id: 1)).to eq "/admin/categories/1/posts"
    end

    it "should nest the instance path" do
      expect(config.route_instance_path(post)).to eq "/admin/categories/1/posts/3"
    end
  end

  context "for batch_action handler" do
    before do
      load_resources { config.batch_actions = true }
    end

    context "when register a singular resource" do

      let :config do
        ActiveAdmin.register Category
        ActiveAdmin.register Post do
          belongs_to :category
        end
      end

      it "should include :scope and :q params" do
        params = ActionController::Parameters.new(category_id: 1, q: { name_equals: "Any" }, scope: :all)
        additional_params = { locale: 'en' }
        batch_action_path = "/admin/categories/1/posts/batch_action?locale=en&q%5Bname_equals%5D=Any&scope=all"

        expect(config.route_batch_action_path(params, additional_params)).to eq batch_action_path
      end
    end

    context "when registering a plural resource" do

      class ::News; def self.has_many(*); end end
      let(:config) { ActiveAdmin.register News }

      it "should return the plural batch action route with _index and given params" do
        params = ActionController::Parameters.new(q: { name_equals: "Any" }, scope: :all)
        additional_params = { locale: 'en' }
        batch_action_path = "/admin/news/batch_action?locale=en&q%5Bname_equals%5D=Any&scope=all"
        expect(config.route_batch_action_path(params, additional_params)).to eq batch_action_path
      end
    end
  end
end
