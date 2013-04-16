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

    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, :title => "My Awesome Comment"
        end
      end

      subject { find_before_filter controller, :comment }

      it { should set_page_title_to "My Awesome Comment" }
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
        controller.active_admin_config.collection_actions.size.should == 1
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
    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments, :title => "My Awesome Comments"
        end
      end

      subject { find_before_filter controller, :comments }

      it { should set_page_title_to "My Awesome Comments" }
    end
  end

  def find_before_filter(controller, action)
    controller._process_action_callbacks.detect { |f| f.kind == :before && f.options[:only] == [action] }
  end

  RSpec::Matchers.define :set_page_title_to do |expected|
    match do |filter|
      filter.raw_filter.call
      @actual = filter.klass.instance_variable_get(:@page_title)
      @actual == expected
    end

    failure_message_for_should do |filter|
      message = "expected before_filter to set the @page_title to '#{expected}', but was '#{@actual}'"
    end
  end
end
