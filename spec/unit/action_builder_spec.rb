require 'rails_helper'

def app_routes
  Rails.application.routes.routes.map do |route|
    {
      path: route.path.spec.to_s,
      verb: %W{GET POST PUT PATCH DELETE}.grep(route.verb).first.to_s.downcase.to_sym
    }
  end
end

def render_text(text)
  word = ActiveAdmin::Dependency.rails5? ? 'plain' : 'text'
  render :"#{word}" => text
end

describe 'defining actions from registration blocks', type: :controller do
  let(:klass){ Admin::PostsController }
  render_views # https://github.com/rspec/rspec-rails/issues/860

  before do
    @controller = klass.new
  end

  describe 'creates a member action' do
    before do
      action!
      reload_routes!
    end

    after(:each) do
      klass.clear_member_actions!
    end

    context 'with a block' do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment do
            # Do nothing
          end
        end
      end

      it 'should create a new public instance method' do
        expect(klass.public_instance_methods.collect(&:to_s)).to include('comment')
      end

      it 'should add itself to the member actions config' do
        expect(klass.active_admin_config.member_actions.size).to eq 1
      end

      it 'should create a new named route' do
        expect(Rails.application.routes.url_helpers.methods.collect(&:to_s)).to include('comment_admin_post_path')
      end
    end

    context 'without a block' do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment
        end
      end

      it 'should still generate a new empty action' do
        expect(klass.public_instance_methods.collect(&:to_s)).to include('comment')
      end
    end

    context 'with :title' do
      let(:action!) do
        ActiveAdmin.register Post do
          member_action :comment, title: 'My Awesome Comment' do
            render json: {a: 2}
          end
        end
      end

      it 'sets the page title' do
        params = {id: 1}
        params = {params: params} if ActiveAdmin::Dependency.rails5?
        get :comment, params

        expect(controller.instance_variable_get(:@page_title)).to eq 'My Awesome Comment'
      end
    end

    context "when several actions with the same name" do
      let(:routes) do
        app_routes.select do |route|
          route[:path].starts_with?("/admin/posts/:id/my_action")
        end
      end

      let(:params) do
        params = {id: 1}
        params = {params: params} if ActiveAdmin::Dependency.rails5?
        params
      end

      context "with the same http method" do
        let(:action!) do
          ActiveAdmin.register Post do
            member_action(:my_action, method: :get) { render_text "get1" }
            member_action(:my_action, method: :get) { render_text "get2" }
          end
        end

        it "should create only one route" do
          expect(routes.map { |r| r[:verb] }).to eq [:get]
        end

        it "should override previous action" do
          get "my_action", params
          expect(response.body).to eq "get2"
        end
      end

      context "with different http methods" do
        let(:action!) do
          ActiveAdmin.register Post do
            member_action(:my_action, method: :get) { render_text "get" }
            member_action(:my_action, method: [:put, :post]) { render_text "put, post" }
            member_action(:my_action, method: :delete) { render_text "delete" }
          end
        end

        it "should create a route for each http method" do
          expect(routes.map { |r| r[:verb] }.sort).to eq [:delete, :get, :post, :put]
        end

        it "should add behaviour to existing action" do
          get "my_action", params
          expect(response.body).to eq "get"

          post "my_action", params
          expect(response.body).to eq "put, post"

          put "my_action", params
          expect(response.body).to eq "put, post"

          delete "my_action", params
          expect(response.body).to eq "delete"
        end
      end

      context "with the same and different http methods" do
        let(:action!) do
          ActiveAdmin.register Post do
            member_action(:my_action, method: :get) { render_text "get1" }

            member_action :my_action, method: [:get, :post] do
              render_text "get2, post1"
            end

            member_action :my_action, method: [:post, :put] do
              render_text "post2, put1"
            end

            member_action :my_action, method: [:post, :delete] do
              render_text "post3, delete1"
            end
          end
        end

        it "should create a single route for each unique http method" do
          expect(routes.map { |r| r[:verb] }.sort).to eq [:delete, :get, :post, :put]
        end

        it "should override previous behaviour with the same http method \
          and add behaviour to existing action with different http method" do

          get "my_action", params
          expect(response.body).to include("get2")

          post "my_action", params
          expect(response.body).to include("post3")

          put "my_action", params
          expect(response.body).to include("put1")

          delete "my_action", params
          expect(response.body).to include("delete1")
        end
      end
    end
  end

  describe 'creates a collection action' do
    before do
      action!
      reload_routes!
    end

    after(:each) do
      klass.clear_collection_actions!
    end

    context 'with a block' do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments do
            # Do nothing
          end
        end
      end

      it 'should create a public instance method' do
        expect(klass.public_instance_methods.collect(&:to_s)).to include('comments')
      end

      it 'should add itself to the member actions config' do
        expect(klass.active_admin_config.collection_actions.size).to eq 1
      end

      it 'should create a named route' do
        expect(Rails.application.routes.url_helpers.methods.collect(&:to_s)).to include('comments_admin_posts_path')
      end
    end

    context 'without a block' do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments
        end
      end

      it 'should still generate a new empty action' do
        expect(klass.public_instance_methods.collect(&:to_s)).to include('comments')
      end
    end

    context 'with :title' do
      let(:action!) do
        ActiveAdmin.register Post do
          collection_action :comments, title: 'My Awesome Comments' do
            render json: {a: 2}
          end
        end
      end

      it 'sets the page title' do
        get :comments

        expect(controller.instance_variable_get(:@page_title)).to eq 'My Awesome Comments'
      end
    end

    context "when several actions with the same name" do
      let(:routes) do
        app_routes.select do |route|
          route[:path].starts_with?("/admin/posts/my_action")
        end
      end

      let(:text) { ActiveAdmin::Dependency.rails5? ? 'plain' : 'text' }

      context "with the same http method" do
        let(:action!) do
          ActiveAdmin.register Post do
            collection_action(:my_action, method: :get) { render_text "get1" }
            collection_action(:my_action, method: :get) { render_text "get2" }
          end
        end

        it "should create only one route" do
          expect(routes.map { |r| r[:verb] }).to eq [:get]
        end

        it "should override previous action" do
          get "my_action"
          expect(response.body).to eq "get2"
        end
      end

      context "with different http methods" do
        let(:action!) do
          ActiveAdmin.register Post do
            collection_action(:my_action, method: :get) { render_text "get" }
            collection_action(:my_action, method: [:put, :post]) { render_text "put, post" }
            collection_action(:my_action, method: :delete) { render_text "delete" }
          end
        end

        it "should create a route for each http method" do
          expect(routes.map { |r| r[:verb] }.sort).to eq [:delete, :get, :post, :put]
        end

        it "should add behaviour to existing action" do
          get "my_action"
          expect(response.body).to eq "get"

          post "my_action"
          expect(response.body).to eq "put, post"

          put "my_action"
          expect(response.body).to eq "put, post"

          delete "my_action"
          expect(response.body).to eq "delete"
        end
      end

      context "with the same and different http methods" do
        let(:action!) do
          ActiveAdmin.register Post do
            collection_action(:my_action, method: :get) { render_text "get1" }

            collection_action :my_action, method: [:get, :post] do
              render_text "get2, post1"
            end

            collection_action :my_action, method: [:post, :put] do
              render_text "post2, put1"
            end

            collection_action :my_action, method: [:post, :delete] do
              render_text "post3, delete1"
            end
          end
        end

        it "should create a single route for each unique http method" do
          expect(routes.map { |r| r[:verb] }.sort).to eq [:delete, :get, :post, :put]
        end

        it "should override previous behaviour with the same http method \
          and add behaviour to existing action with different http method" do

          get "my_action"
          expect(response.body).to include("get2")

          post "my_action"
          expect(response.body).to include("post3")

          put "my_action"
          expect(response.body).to include("put1")

          delete "my_action"
          expect(response.body).to include("delete1")
        end
      end
    end
  end
end
