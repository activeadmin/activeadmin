require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Show View" do

  before :all do
    load_defaults!
    reload_routes!
  end

  describe "GET #show" do
    before(:each) do
      Admin::PostsController.reset_show_config!
    end

    describe "the page title" do
      before do
        @post = Post.create :title => "Hello World"
        Admin::PostsController.show(:title => title)
        get :show, :id => @post.id
      end

      context "with default" do
        let(:title){ nil }
        it "should render the type and id" do
          response.should have_tag("h2", "Post ##{@post.id}") 
        end
      end

      context "with a symbol set" do
        let(:title) { :title }
        it "should call the method on the object and render the response" do
          response.should have_tag("h2", @post.title)
        end
      end

      context "with a string set" do
        let(:title) { "Hey Hey" }
        it "should render the string" do
          response.should have_tag("h2", "Hey Hey")
        end
      end

      context "with a block set" do
        let(:title) { proc{|r| r.title } }
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
    
    context "with custom output" do
      before(:each) do
        Admin::PostsController.show do
          "Woot Bang"
        end
        @post = Post.create(:title => "Hello World", :body => "Woot Woot")
        get :show, :id => @post.id
      end
      
      it "should render contents" do
        response.body.should include("Woot Bang")
      end
    end
    
    describe "admin notes" do
      
      context "without notes" do
        before(:each) do
          @post = Post.create(:title => "Hello World", :body => "Woot Woot")
          get :show, :id => @post.id
        end
        
        it "should have an empty message" do
          response.body.should include("No admin notes yet for this post")
        end
        
        it "should have a note form" do
          response.should have_tag(:form, :attributes => {:action => "/admin/admin_notes", :method => "post"})
        end
        
        it "should have a hidden entity_id field" do
          response.should have_tag(:input, :attributes => {:type => "hidden", :name => "active_admin_admin_note[entity_id]"})
        end
        
        it "should have a hidden entity_type field" do
          response.should have_tag(:input, :attributes => {:type => "hidden", :name => "active_admin_admin_note[entity_type]"})
        end
        
        it "should have a textarea" do
          response.should have_tag(:textarea)
        end
        
        it "should have a submit button" do
          response.should have_tag(:input, :attributes => {:type => "submit"})
        end
        
      end
      
      context "with notes" do
        before(:each) do
          @post = Post.create(:title => "Hello World", :body => "Woot Woot")
          @post.admin_notes.create(:body => "This is a note")
          get :show, :id => @post.id
        end
        
        it "should not have an empty message" do
          response.body.should_not include("No admin notes yet for this post")
        end
        
        it "should have a note form" do
          response.should have_tag(:form, :attributes => {:action => "/admin/admin_notes", :method => "post"})
        end
        
        it "should have notes" do
          response.body.should include("This is a note")
        end
        
      end
    end
  end
end
