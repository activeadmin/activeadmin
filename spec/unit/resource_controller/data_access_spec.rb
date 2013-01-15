require 'spec_helper'

describe ActiveAdmin::ResourceController::DataAccess do
  let(:params) do
    {}
  end

  let(:controller) do
    rc = Admin::PostsController.new
    rc.stub!(:params) do
      params
    end
    rc
  end

  describe "searching" do
    let(:params){ {:q => {} }}

    it "should call the metasearch method" do
      chain = mock("ChainObj")
      chain.should_receive(:metasearch).with(params[:q]).once.and_return(Post.search)
      controller.send :apply_filtering, chain
    end

  end

  describe "sorting" do

    context "for table columns" do
      let(:params){ {:order => "id_asc" }}
      it "should prepend the table name" do
        chain = mock("ChainObj")
        chain.should_receive(:reorder).with("\"posts\".\"id\" asc").once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

    context "for virtual columns" do
      let(:params){ {:order => "virtual_id_asc" }}
      it "should not prepend the table name" do
        chain = mock("ChainObj")
        chain.should_receive(:reorder).with("\"virtual_id\" asc").once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

  end

  describe "scoping" do

    context "when no current scope" do
      it "should set collection_before_scope to the chain and return the chain" do
        chain = mock("ChainObj")
        controller.send(:apply_scoping, chain).should == chain
        controller.send(:collection_before_scope).should == chain
      end
    end

    context "when current scope" do
      it "should set collection_before_scope to the chain and return the scoped chain" do
        chain = mock("ChainObj")
        scoped_chain = mock("ScopedChain")
        current_scope = mock("CurrentScope")
        controller.stub!(:current_scope) { current_scope }

        controller.should_receive(:scope_chain).with(current_scope, chain) { scoped_chain }
        controller.send(:apply_scoping, chain).should == scoped_chain
        controller.send(:collection_before_scope).should == chain
      end
    end

  end

end
