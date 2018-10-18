require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::DataAccess do
  before do
    load_resources { config }
  end

  let(:config) do
    ActiveAdmin.register Post do
    end
  end

  let(:http_params) do
    {}
  end

  let(:params) do
    ActionController::Parameters.new(http_params)
  end

  let(:controller) do
    rc = Admin::PostsController.new
    allow(rc).to receive(:params) do
      params
    end
    rc
  end

  describe "searching" do
    let(:http_params) {{ q: {} }}
    it "should call the search method" do
      chain = double "ChainObj"
      expect(chain).to receive(:ransack).with(params[:q]).once.and_return(Post.ransack)
      controller.send :apply_filtering, chain
    end

    context "params includes empty values" do
      let(:http_params) do
        { q: {id_eq: 1, position_eq: ""} }
      end
      it "should return relation without empty filters" do
        expect(Post).to receive(:ransack).with(params[:q]).once.and_wrap_original do |original, *args|
          chain = original.call(*args)
          expect(chain.conditions.size).to eq(1)
          chain
        end
        controller.send :apply_filtering, Post
      end
    end
  end

  describe "sorting" do

    context "valid clause" do
      let(:http_params) {{ order: "id_asc" }}

      it "reorders chain" do
        chain = double "ChainObj"
        expect(chain).to receive(:reorder).with('"posts"."id" asc').once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

    context "invalid clause" do
      let(:http_params) {{ order: "_asc" }}

      it "returns chain untouched" do
        chain = double "ChainObj"
        expect(chain).not_to receive(:reorder)
        expect(controller.send(:apply_sorting, chain)).to eq chain
      end
    end

    context "custom strategy" do
      before do
        expect(controller.send(:active_admin_config)).to receive(:ordering).twice.and_return(
          {
            published_date: proc do |order_clause|
              [order_clause.to_sql, 'NULLS LAST'].join(' ') if order_clause.order == 'desc'
            end
          }.with_indifferent_access
        )
      end

      context "when params applicable" do
        let(:http_params) {{ order: "published_date_desc" }}
        it "reorders chain" do
          chain = double "ChainObj"
          expect(chain).to receive(:reorder).with('"posts"."published_date" desc NULLS LAST').once.and_return(Post.search)
          controller.send :apply_sorting, chain
        end
      end
      context "when params not applicable" do
        let(:http_params) {{ order: "published_date_asc" }}
        it "reorders chain" do
          chain = double "ChainObj"
          expect(chain).to receive(:reorder).with('"posts"."published_date" asc').once.and_return(Post.search)
          controller.send :apply_sorting, chain
        end
      end
    end

  end

  describe "scoping" do

    context "when no current scope" do
      it "should set collection_before_scope to the chain and return the chain" do
        chain = double "ChainObj"
        expect(controller.send(:apply_scoping, chain)).to eq chain
        expect(controller.send(:collection_before_scope)).to eq chain
      end
    end

    context "when current scope" do
      it "should set collection_before_scope to the chain and return the scoped chain" do
        chain = double "ChainObj"
        scoped_chain = double "ScopedChain"
        current_scope = double "CurrentScope"
        allow(controller).to receive(:current_scope) { current_scope }

        expect(controller).to receive(:scope_chain).with(current_scope, chain) { scoped_chain }
        expect(controller.send(:apply_scoping, chain)).to eq scoped_chain
        expect(controller.send(:collection_before_scope)).to eq chain
      end
    end
  end

  describe "includes" do
    context "with no includes" do
      it "should return the chain" do
        chain = double "ChainObj"
        expect(controller.send(:apply_includes, chain)).to eq chain
      end
    end

    context "with includes" do
      it "should return the chain with the includes" do
        chain = double "ChainObj"
        chain_with_includes = double "ChainObjWithIncludes"
        expect(chain).to receive(:includes).with(:taggings, :author).and_return(chain_with_includes)
        expect(controller.send(:active_admin_config)).to receive(:includes).twice.and_return([:taggings, :author])
        expect(controller.send(:apply_includes, chain)).to eq chain_with_includes
      end
    end
  end

  describe "find_collection" do
    let(:appliers) do
      ActiveAdmin::ResourceController::DataAccess::COLLECTION_APPLIES
    end
    let(:scoped_collection) do
      double "ScopedCollectionChain"
    end
    before do
      allow(controller).to receive(:scoped_collection).
        and_return(scoped_collection)
    end

    it "should return chain with all appliers " do
      appliers.each do |applier|
        expect(controller).to receive("apply_#{applier}").
          with(scoped_collection).
          once.
          and_return(scoped_collection)
      end
      expect(controller).to receive(:collection_applies).
        with({}).and_call_original.once
      controller.send :find_collection
    end

    describe "collection_applies" do
      context "excepting appliers" do
        let(:options) do
          { except:
              [:authorization_scope, :filtering, :scoping, :collection_decorator]
          }
        end

        it "should except appliers" do
          expect(controller.send :collection_applies, options).
            to eq([:sorting, :includes, :pagination])
        end
      end

      context "specifying only needed appliers" do
        let(:options) do
          { only: [:filtering, :scoping] }
        end
        it "should except appliers" do
          expect(controller.send :collection_applies, options).to eq(options[:only])
        end
      end
    end
  end

  describe "build_resource" do

    let(:config) do
      ActiveAdmin.register User do
        permit_params :type, posts_attributes: :custom_category_id
      end
    end

    let!(:category) { Category.create! }

    let(:params) do
      ActionController::Parameters.new(user: { type: 'User::VIP', posts_attributes: [custom_category_id: category.id] })
    end

    subject do
      controller.send :build_resource
    end

    let(:controller) do
      rc = Admin::UsersController.new
      allow(rc).to receive(:params) do
        params
      end
      rc
    end

    it "should return post with assigned attributes" do
      expect(subject).to be_a(User::VIP)
    end

    # see issue 4548
    it "should assign nested attributes once" do
      expect(subject.posts.size).to eq(1)
    end

  end

end
