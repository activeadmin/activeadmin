require 'spec_helper'

describe ActiveAdmin::ResourceController::DataAccess do
  let(:params) do
    {}
  end

  let(:controller) do
    rc = Admin::PostsController.new
    allow(rc).to receive(:params) do
      params
    end
    rc
  end

  describe "searching" do
    let(:params) {{ q: {} }}
    it "should call the search method" do
      chain = double "ChainObj"
      expect(chain).to receive(:ransack).with(params[:q]).once.and_return(Post.ransack)
      controller.send :apply_filtering, chain
    end
  end

  describe "sorting" do

    context "valid clause" do
      let(:params) {{ order: "id_asc" }}

      it "reorders chain" do
        chain = double "ChainObj"
        expect(chain).to receive(:reorder).with('"posts"."id" asc').once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

    context "invalid clause" do
      let(:params) {{ order: "_asc" }}

      it "returns chain untouched" do
        chain = double "ChainObj"
        expect(chain).not_to receive(:reorder)
        expect(controller.send(:apply_sorting, chain)).to eq chain
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
        chain         = double "ChainObj"
        scoped_chain  = double "ScopedChain"
        current_scope = double "CurrentScope"
        allow(controller).to receive(:current_scope) { current_scope }

        expect(controller).to receive(:scope_chain).with(current_scope, chain) { scoped_chain }
        expect(controller.send(:apply_scoping, chain)).to eq scoped_chain
        expect(controller.send(:collection_before_scope)).to eq chain
      end
    end
  end

end
