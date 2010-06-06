require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe Admin::PostsController, :type => :controller do

  include RSpec::Rails::ControllerExampleGroup
  render_views

  before(:each) do
    Admin::PostsController.reset_index_config!
  end

  describe "GET #index" do
    before(:each) do
      @post = Post.create(:title => "Hello World")
    end

    describe "in general" do
      it "should have a breadcrumb" do
        get :index
        response.should have_tag("a", "Dashboard")
      end
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
      it "should render a table with default sortable headers" do
        response.should have_tag("a", :content => "Title", 
                                      :parent => { :tag => "th" })
        # I should be able to match against the url attribute, but it doesn't want to work
                                      # :attributes => { 'href' => "/admin/posts?order=title_desc"})
        # So instead, we'll check that it exists
        response.body.should match(/\"\/admin\/posts\?order\=title_desc\"/)
      end
      it "should render the sortable header for ascending if we are currently sorted descending" do
        get :index, 'order' => 'title_desc'
        response.body.should match(/\"\/admin\/posts\?order\=title_asc\"/)
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
    
    describe "hiding columns" do
      before(:each) do
        Admin::PostsController.index do |i|
          i.column :title, :if => lambda{ false }
          i.column :body
        end
        get :index
      end
      it "should not show columns which conditionals eval to false" do
        response.should_not have_tag("th", "Title")
      end
    end
  end

  describe "ordering get #index" do
    before(:each) do
      @yesterday = Post.create :title => "Yesterday", :created_at => Time.now - 1.day
      @today = Post.create :title => "Today"
    end
    it "should sort ascending" do
      get :index, 'order' => 'created_at_asc'
      response.body.scan(/Yesterday|Today/).should == ["Yesterday", "Today"] 
    end
    it "should sort descending" do
      get :index, 'order' => 'created_at_desc'
      response.body.scan(/Yesterday|Today/).should == ["Today", "Yesterday"] 
    end
  end

  describe "searching" do
    before do
      Post.create :title => "Hello World"
      Post.create :title => "Goodbye World"
      get :index, 'q' => { 'title_like' => 'hello' }
    end
    it "should find posts based on search" do
      response.body.should include("Hello World")
    end
    it "should not includes posts that don't meet the search" do
      response.body.should_not include("Goodbye")
    end
    it "should set @search for the view" do
      assigns["search"].should_not be_nil
    end
  end
end
