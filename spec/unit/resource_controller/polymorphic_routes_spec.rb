require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::PolymorphicRoutes, type: :controller do
  let(:klass) { Admin::PostsController }

  shared_context 'with post config' do
    before do
      load_resources { post_config }

      @controller = klass.new

      get :index
    end
  end

  context 'polymorphic routes' do
    include_context 'with post config' do
      let(:post_config) { ActiveAdmin.register Post }
      let(:post) { Post.create! title: "Hello World" }
    end

    %w(polymorphic_url polymorphic_path).each do |method|
      describe method do
        it 'arrays wtih action names' do
          expect(controller.send(method, [:admin, post])).to include("/admin/posts/#{post.id}")
        end
      end
    end
  end
end
