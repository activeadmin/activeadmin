require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Index as Table" do

  before :all do
    load_defaults!
    reload_routes!
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
