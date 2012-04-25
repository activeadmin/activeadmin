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
      chain.should_receive(:reorder).with("\"posts\".\"id\" asc").once.and_return(Post.search)
      controller.send :sort_order, chain
    end
  end
  
  describe ActiveAdmin::ResourceController::Collection::Scoping do
    it "should assign @before_scope_collection if a scope_to is registered" do
      chain = mock("ChainObj")
      scoped_collection = mock('scoped_collection')
      controller.stub(:current_scope).and_return(false)
      controller.stub(:scoped_collection).and_return(scoped_collection)
      controller.stub_chain(:active_admin_config, :scope_to).and_return(true)
      
      controller.send :scope_current_collection, chain
      controller.instance_variable_get('@before_scope_collection').should == scoped_collection
    end
  end

end
