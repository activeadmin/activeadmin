require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe Admin::PostsController, :type => :controller do

  if defined? ControllerExampleGroupBehaviour
    # Rails 3 with Rspec 2
    include ControllerExampleGroupBehaviour
  else
    integrate_views  
  end

  before(:each) do
    Admin::PostsController.reset_index_config!
  end

  describe "GET #index" do
    before(:each) do
      @post = Post.create(:title => "Hello World")
    end
    
    describe "with default table" do
      before(:each) do
        get :index
      end
      it "should render a header for the section" do
        response.should have_tag("h2", "Posts")
      end
      it "should render a new link" do
        response.should have_tag("a", "New Post", :attributes => {:href => "/admin/posts/new"})
      end
      it "should render a table with default headers" do
        response.should have_tag("th", "Title")
      end
      it "should render a view link" do
        response.should have_tag("a", "View")
      end
      it "should render an edit link" do
        response.should have_tag("a", "Edit")
      end
      it "should render a delete link" do
        response.should have_tag("a", "Delete")
      end
    end
    
    describe "with symbol column keys" do
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
