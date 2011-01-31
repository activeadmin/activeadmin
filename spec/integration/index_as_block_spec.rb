require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Index as Block" do

  before do
    @post = Post.create(:title => "Hello World", :body => "This is the hello world post")
    ActiveAdmin.register Post do
      index :as => :block do |post|
        link_to post.title, admin_post_path(post)
      end
    end
    reload_routes!
    get :index
  end

  it "should render the block for each resource in the collection" do
    response.should have_tag("a", "Hello World")
  end

end
