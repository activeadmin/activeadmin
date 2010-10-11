require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Index as Blog" do

  before :all do
    load_defaults!
    reload_routes!
  end

  before do
    @post = Post.create(:title => "Hello World", :body => "This is the hello world post")
  end

  describe "displaying the index as posts" do

    context "when no configuration block given" do
      before do
        ActiveAdmin.register Post do
          index :as => :blog 
        end
        get :index
      end      

      it "should have an h3 as the title" do
        response.should have_tag("h3", "Post #{@post.id}")
      end
      it "should generate a title link" do
        response.should have_tag("a", "Post #{@post.id}", :attributes => {
                                                            :href => "/admin/posts/#{@post.id}" })
      end
    end

    context "when a simple config given" do
      before do
        ActiveAdmin.register Post do
          index :as => :blog do |i|
            i.title :title
            i.content :body
          end
        end
        get :index
      end
      it "should render the title" do
        response.should have_tag("h3", "Hello World")
      end
      it "should render the body as the content" do
        response.should have_tag("div", @post.body, :attributes => { :class => 'content' } )
      end
    end

    context "when blocks given as config" do
      before do
        ActiveAdmin.register Post do
          index :as => :blog do |i|
            i.title {|post| post.title }
            i.content {|post| simple_format post.body }
          end
        end
        get :index
      end
      it "should render the title" do
        response.should have_tag("h3", "Hello World")
      end
      it "should render the body as the content" do
        response.should have_tag("div", @post.body, :attributes => { :class => 'content' } )
      end      
    end

  end
end
