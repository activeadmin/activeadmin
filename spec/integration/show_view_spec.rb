require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Show View" do

  describe "GET #show" do

    describe "action items" do
      before do
        @post = Post.create(:title => "Hello World", :body => "Woot Woot")
        get :show, :id => @post.id
      end
      it "should have a delete button" do
        response.should have_tag("a", "Delete Post", :attributes => { 'data-method' => 'delete' })
      end
      it "should have an edit button" do
        response.should have_tag("a", "Edit Post")
      end
    end

    context "with default output" do
      before do
        @post = Post.create(:title => "Hello World", :body => "Woot Woot")
        get :show, :id => @post.id
      end

      it "should render default view" do
        response.should have_tag("th", "Title")
        response.should have_tag('td', 'Hello World')
      end
    end

  end
end
