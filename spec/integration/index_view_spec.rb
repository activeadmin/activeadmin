require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe Admin::PostsController, :type => :controller do

  integrate_views

  before(:each) do
    Admin::PostsController.reset_index_config!
  end

  describe "GET #index" do
    before(:each) do
      @post = Post.create(:title => "Hello World")
    end
    
    describe "with default table" do
      it "should render a table with default headers" do
        get :index
        response.should have_tag("th", "Title")
      end
    end
    
    describe "with symbol colum keys" do
      before(:each) do
        Admin::PostsController.index do |i|
          i.column :title
        end
        Post.create(:title => "Hello World", :body => "Woot Woot")
        get :index
      end

      it "should show the specified columns" do
        response.should have_tag("th", "Title")
      end
      
      it "should show the column data" do
        response.should have_tag("td", "Hello World")
      end

      it "should not show specified columns" do
        response.should_not have_tag("th", "Body")
      end
    end
    
    describe "with block column keys" do
      before(:each) do
        Admin::PostsController.index do |i|
          i.column('Great Titles'){ link_to @post.title, [:admin, @post] }
        end
        Post.create(:title => "Hello World", :body => "Woot Woot")
        get :index
      end

      it "should show the specified columns" do
        response.should have_tag("th", "Great Titles")
      end
      
      it "should render the block in the view" do
        response.should have_tag("a", "Hello World")
      end
      
      it "should show the column data" do
        response.should have_tag("td", "Hello World")
      end
    end    
    
  end
end
