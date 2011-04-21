require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Show View" do

  describe "GET #show" do
    describe "the page title" do
      before do
        @post = Post.create :title => "Hello World"
      end

      context "with default" do
        before do
          ActiveAdmin.register Post do
            show :title => nil
          end
          get :show, :id => @post.id
        end

        it "should render the type and id" do
          response.should have_tag("h2", "Post ##{@post.id}") 
        end
      end

      context "with a symbol set" do
        before do
          ActiveAdmin.register Post do
            show :title => :title
          end
          self.class.metadata[:behaviour][:describes] = Admin::PostsController
          get :show, :id => @post.id
        end
        it "should call the method on the object and render the response" do
          response.should have_tag("h2", @post.title)
        end
      end

      context "with a string set" do
        before do
          ActiveAdmin.register Post do
            show :title => "Hey Hey"
          end
          get :show, :id => @post.id
        end
        it "should render the string" do
          response.should have_tag("h2", "Hey Hey")
        end
      end

      context "with a block set" do
        before do
          ActiveAdmin.register Post do
            show :title => proc{|p| p.title }
          end
          get :show, :id => @post.id
        end
        it "should render the proc with the object as a param" do
          response.should have_tag("h2", @post.title)
        end
      end

    end

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
