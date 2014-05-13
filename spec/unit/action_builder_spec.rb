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
        expect(controller.public_instance_methods.collect(&:to_s)).to include("comment")
      end
      it "should add itself to the member actions config" do
        expect(controller.active_admin_config.member_actions.size).to eq 1
      end
      it "should create a new named route" do
        expect(Rails.application.routes.url_helpers.methods.collect(&:to_s)).to include("comment_admin_post_path")
      end
    end

    context "without a block" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment
        end
      end
      it "should still generate a new empty action" do
        expect(controller.public_instance_methods.collect(&:to_s)).to include("comment")
      end
    end

    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, title: "My Awesome Comment"
        end
      end

      subject { find_before_filter controller, :comment }

      it { should set_page_title_to "My Awesome Comment", for: controller }
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
        expect(controller.public_instance_methods.collect(&:to_s)).to include("comments")
      end
      it "should add itself to the member actions config" do
        expect(controller.active_admin_config.collection_actions.size).to eq 1
      end
      it "should create a new named route" do
        expect(Rails.application.routes.url_helpers.methods.collect(&:to_s)).to include("comments_admin_posts_path")
      end
    end
    context "without a block" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments
        end
      end
      it "should still generate a new empty action" do
        expect(controller.public_instance_methods.collect(&:to_s)).to include("comments")
      end
    end
    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments, title: "My Awesome Comments"
        end
      end

      subject { find_before_filter controller, :comments }

      it { should set_page_title_to "My Awesome Comments", for: controller }
    end
  end

  def find_before_filter(controller, action)
    finder = if ActiveAdmin::Dependency.rails? '>= 4.1.0'
      ->c { c.kind == :before && c.instance_variable_get(:@if) == ["action_name == '#{action}'"] }
    else
      ->c { c.kind == :before && c.options[:only] == [action] }
    end

    controller._process_action_callbacks.detect &finder
  end

  RSpec::Matchers.define :set_page_title_to do |expected, options|
    match do |filter|
      filter.raw_filter.call
      @actual = options[:for].instance_variable_get(:@page_title)
      expect(@actual).to eq expected
    end

    failure_message_for_should do |filter|
      message = "expected before_filter to set the @page_title to '#{expected}', but was '#{@actual}'"
    end
  end
end
