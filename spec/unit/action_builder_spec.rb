require 'rails_helper'

RSpec.describe 'defining actions from registration blocks', type: :controller do
  let(:klass){ Admin::PostsController }

  before do
    load_resources { action! }

    @controller = klass.new
  end

  describe 'creates a member action' do
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
  end

  describe 'creates a collection action' do
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
  end
end
