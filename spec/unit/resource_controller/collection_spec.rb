require 'spec_helper'

describe ActiveAdmin::ResourceController::Collection do
  let(:params) do
    {}
  end

  let(:controller) do
    rc = ActiveAdmin::ResourceController.new
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

end
