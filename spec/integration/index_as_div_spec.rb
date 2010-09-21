require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Index as Div" do

  before :all do
    load_defaults!
    reload_routes!
  end

  before do
    Admin::PostsController.reset_index_config!
    @post = Post.create(:title => "Hello World", :body => "This is the hello world post")
    Admin::PostsController.index :as => :div do |post|
      link_to post.title, admin_post_path(post)
    end
    get :index
  end

  it "should render a div for each resource" do
    response.should have_tag("div", :attributes => { :id => "post_#{@post.id}" })
  end

  it "should render the block with the resource being passed in" do
    response.should have_tag("a", "Hello World")
  end

end
