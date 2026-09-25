# frozen_string_literal: true
require "rails_helper"

RSpec.describe "defining actions from registration blocks", type: :controller do
  let(:klass) { Admin::PostsController }

  before do
    load_resources { action! }

    @controller = klass.new
  end

  describe "creates a member action" do
    after do
      klass.clear_member_actions!
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
        expect(klass.public_instance_methods.collect(&:to_s)).to include("comment")
      end

      it "should add itself to the member actions config" do
        expect(klass.active_admin_config.member_actions.size).to eq 1
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
        expect(klass.public_instance_methods.collect(&:to_s)).to include("comment")
      end
    end

    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, title: "My Awesome Comment" do
            render json: { a: 2 }
          end
        end
      end

      it "sets the page title" do
        get :comment, params: { id: 1 }

        expect(controller.instance_variable_get(:@page_title)).to eq "My Awesome Comment"
      end
    end

    context "with :if proc" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, if: -> { params[:allowed] == "true" } do
            render json: { a: 2 }
          end
        end
      end

      context "when the proc returns a truthy value" do
        it "allows the request" do
          get :comment, params: { id: 1, allowed: "true" }

          expect(response).to be_successful
        end
      end

      context "when the proc returns a falsey value" do
        it "raises a routing error" do
          expect { get :comment, params: { id: 1 } }.to raise_error ActionController::RoutingError
        end
      end
    end

    context "with :if symbol" do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, if: :comment_allowed? do
            render json: { a: 2 }
          end

          controller do
            private

            def comment_allowed?
              params[:allowed] == "true"
            end
          end
        end
      end

      context "when the method returns a truthy value" do
        it "allows the request" do
          get :comment, params: { id: 1, allowed: "true" }

          expect(response).to be_successful
        end
      end

      context "when the method returns a falsey value" do
        it "raises a routing error" do
          expect { get :comment, params: { id: 1 } }.to raise_error ActionController::RoutingError
        end
      end
    end
  end

  describe "creates a collection action" do
    after do
      klass.clear_collection_actions!
    end

    context "with a block" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments do
            # Do nothing
          end
        end
      end

      it "should create a public instance method" do
        expect(klass.public_instance_methods.collect(&:to_s)).to include("comments")
      end

      it "should add itself to the member actions config" do
        expect(klass.active_admin_config.collection_actions.size).to eq 1
      end

      it "should create a named route" do
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
        expect(klass.public_instance_methods.collect(&:to_s)).to include("comments")
      end
    end

    context "with :title" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments, title: "My Awesome Comments" do
            render json: { a: 2 }
          end
        end
      end

      it "sets the page title" do
        get :comments

        expect(controller.instance_variable_get(:@page_title)).to eq "My Awesome Comments"
      end
    end

    context "with :if proc" do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments, if: -> { params[:allowed] == "true" } do
            render json: { a: 2 }
          end
        end
      end

      context "when the proc returns a truthy value" do
        it "allows the request" do
          get :comments, params: { allowed: "true" }

          expect(response).to be_successful
        end
      end

      context "when the proc returns a falsey value" do
        it "raises a routing error" do
          expect { get :comments }.to raise_error ActionController::RoutingError
        end
      end
    end
  end

  context "when method with given name is already defined" do
    include_context "capture stderr"

    describe "defining member action" do
      let :action! do
        ActiveAdmin.register Post do
          member_action :process
        end
      end

      it "writes warning to $stderr" do
        expect($stderr.string).to include("Warning: method `process` already defined in Admin::PostsController")
      end
    end

    describe "defining collection action" do
      let :action! do
        ActiveAdmin.register Post do
          collection_action :process
        end
      end

      it "writes warning to $stderr" do
        expect($stderr.string).to include("Warning: method `process` already defined in Admin::PostsController")
      end
    end
  end
end
