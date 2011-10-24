require 'spec_helper' 

describe 'defining new actions from registration blocks' do

  let(:controller){ Admin::PostsController }

  describe "generating a new member action" do
    before do
      action!
      reload_routes!
    end

    after(:each) do
      controller.clear_member_actions!
    end
    
    context "with a block" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment do
            # Do nothing
          end
        end
      end
        
      it "should create a new public instance method" do
        controller.public_instance_methods.collect(&:to_s).should include("comment")
      end
      it "should add itself to the member actions config" do
        controller.active_admin_config.member_actions.size.should == 1
      end
      it "should create a new named route" do
        Rails.application.routes.url_helpers.methods.collect(&:to_s).should include("comment_admin_post_path")
      end
    end

    context "without a block" do
      let(:action!) do 
        ActiveAdmin.register Post do
          member_action :comment
        end
      end
      it "should still generate a new empty action" do
        controller.public_instance_methods.collect(&:to_s).should include("comment")
      end
    end
  end

  describe "generate a new collection action" do
    before do
      action!
      reload_routes!
    end
    after(:each) do
      controller.clear_collection_actions!
    end

    context "with a block" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments do
            # Do nothing
          end
        end
      end
      it "should create a new public instance method" do
        controller.public_instance_methods.collect(&:to_s).should include("comments")
      end
      it "should add itself to the member actions config" do
        controller.active_admin_config.collection_actions.size.should == 2  # There is a default collection_action for batch_action() support
      end
      it "should create a new named route" do
        Rails.application.routes.url_helpers.methods.collect(&:to_s).should include("comments_admin_posts_path")
      end
    end
    context "without a block" do
      let(:action!) do 
        ActiveAdmin.register Post do
          collection_action :comments
        end
      end
      it "should still generate a new empty action" do
        controller.public_instance_methods.collect(&:to_s).should include("comments")
      end
    end
  end

end
