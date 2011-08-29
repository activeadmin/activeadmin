require 'spec_helper'

describe ActiveAdmin::Views::PaginatedCollection do
  describe "creating with the dsl" do
    setup_arbre_context!
    
    let(:collection) do
      posts = [Post.new(:title => "First Post"), Post.new(:title => "Second Post"), Post.new(:title => "Third Post")]
      Kaminari.paginate_array(posts).page(1).per(5)
    end
    
    before do
      request.stub!(:query_parameters).and_return({:controller => 'admin/posts', :action => 'index', :page => '1'})
    end

    context "when specifying collection" do
      let(:pagination) do
        paginated_collection(collection)
      end
      
      it "should set :collection as the passed in collection" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>all 3</b> posts"
      end
      
      it "should raise error if collection has no pagination scope" do
        lambda {
          paginated_collection([Post.new, Post.new])
        }.should raise_error(StandardError, "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection.")
      end
    end
    
    context "when specifying :param_name option" do
      let(:collection) do
        posts = 10.times.inject([]) {|m| m << Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end
      
      let(:pagination) { paginated_collection(collection, :param_name => :post_page) }
      
      before do
        controller.params = {:controller => 'admin/posts', :action => 'index'}
      end 
      
      it "should customize the page number parameter in pagination links" do
        pagination.find_by_tag('div').last.content.should match(/\/admin\/posts\?post_page=2/)
      end
    end
  end  
end