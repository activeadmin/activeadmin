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
      let(:params){ {:order => "foo_column_asc" }}
      it "should delegate to metasearch" do
        chain = mock("ChainObj")
        chain.should_receive(:select_values).once.and_return(['*'])
        chain.should_receive(:metasearch).with(:meta_sort => "foo_column.asc").once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

    context "for virtual columns" do
      let(:params){ {:order => "virtual_id_asc" }}
      it "should not prepend the table name" do
        chain = mock("ChainObj")
        chain.should_receive(:select_values).once.and_return(['foo AS virtual_id'])
        chain.should_receive(:reorder).with("\"virtual_id\" asc").once.and_return(Post.search)
        controller.send :apply_sorting, chain
      end
    end

    context "with the former associate column format" do
      let(:params){ {:order => "puppies.eye_colour_asc" }}

      # https://github.com/gregbell/active_admin/pull/1766#issuecomment-12934911
      it "should be backwards-compatible" do
        chain = mock("ChainObj")
        chain.should_receive(:select_values).once.and_return(['*'])
        chain.should_receive(:metasearch).with(:meta_sort => "puppy_eye_colour.asc").once.and_return(Post.search)
        ActiveAdmin::Deprecation.should_receive(:warn)
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
