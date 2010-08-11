require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 

describe ActiveAdmin::ActionBuilder do

  let(:controller){ Admin::PostsController }

  describe "generating a new member action" do
    before do
      controller.member_action :comment do
        # Do nothing
      end
      reload_routes!
    end

    after(:each) do
      controller.clear_member_actions!
    end
      
    it "should create a new public instance method" do
      controller.public_instance_methods.should include("comment")
    end
    it "should add itself to the member actions config" do
      controller.active_admin_config.member_actions.size.should == 1
    end
    it "should create a new named route" do
      Rails.application.routes.url_helpers.methods.should include("comment_admin_post_path")
    end
  end

  describe "generate a new collection action" do
    before do
      controller.collection_action :comments do
        # Do nothing
      end
      reload_routes!
    end
    after(:each) do
      controller.clear_collection_actions!
    end

    it "should create a new public instance method" do
      controller.public_instance_methods.should include("comments")
    end
    it "should add itself to the member actions config" do
      controller.active_admin_config.collection_actions.size.should == 1
    end
    it "should create a new named route" do
      Rails.application.routes.url_helpers.methods.should include("comments_admin_posts_path")
    end
  end

end
