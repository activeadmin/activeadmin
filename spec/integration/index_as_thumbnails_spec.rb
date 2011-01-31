require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "Index as Thumbnails" do

  before :all do
    load_defaults!
    reload_routes!
  end

  before do
    Admin::PostsController.reset_index_config!
    @post = Post.create(:title => "Hello World", :body => "This is the hello world post")

    # Create a method for a fake thumbnail url
    class Post < ActiveRecord::Base
      def thumbnail_url
        title.downcase.gsub(' ', '-') + ".jpg"
      end
    end
  end

  describe "displaying the index as thumbnails" do

    context "when only setting the image path" do
      before do
        ActiveAdmin.register Post do
          index :as => :thumbnails do |i|
            i.image :thumbnail_url
          end
        end
        get :index
      end
      it "should generate an image" do
        response.should have_tag("img", :attributes => {
                                          :src => "hello-world.jpg",
                                          :width => "200", :height => "200"})
      end
      it "should create a link to the resource" do
        response.should have_tag("a", :attributes => {
                                        :href => "/admin/posts/#{@post.id}" })
      end
    end

  end
end
