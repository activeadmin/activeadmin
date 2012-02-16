require 'spec_helper'

describe ActiveAdmin::ResourceController::Collection do
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

  describe ActiveAdmin::ResourceController::Collection::Search do
    let(:params){ {:q => {} }}
    it "should call the metasearch method" do
      chain = mock("ChainObj")
      chain.should_receive(:metasearch).with(params[:q]).once.and_return(Post.search)
      controller.send :search, chain
    end
  end

  describe ActiveAdmin::ResourceController::Collection::Sorting do
    let(:params){ {:order => "id_asc" }}
    it "should prepend the table name" do
      chain = mock("ChainObj")
      chain.should_receive(:order).with("\"posts\".\"id\" asc").once.and_return(Post.search)
      controller.send :sort_order, chain
    end
  end

end
