require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::PolymorphicRoutes, type: :controller do
  let(:klass) { Admin::PostsController }

  %w(polymorphic_url polymorphic_path).each do |method|
    describe method do
      let(:params) { {} }

      before do
        load_resources { post_config }

        @controller = klass.new

        get :index, params: params
      end

      context 'without belongs_to' do
        let(:post_config) { ActiveAdmin.register Post }
        let(:post) { Post.create! title: "Hello World" }

        it 'works with no parent' do
          expect(controller.send(method, [:admin, post])).to include("/admin/posts/#{post.id}")
        end
      end

      context 'with belongs_to' do
        let(:user) { User.create! }
        let(:post) { Post.create! title: "Hello World", author: user }

        let(:post_config) do
          ActiveAdmin.register User
          ActiveAdmin.register Post do
            belongs_to :user, optional: true
          end
        end

        %w(posts user_posts).each do |current_page|
          context "within the #{current_page} page" do
            let(:filter_param) { current_page.sub(/_?posts/, "").presence }
            let(:params) { filter_param ? { "#{filter_param}_id" => send(filter_param).id } : {} }

            it 'works with no parent' do
              expect(controller.send(method, [:admin, post])).to include("/admin/posts/#{post.id}")
            end

            it 'works with a user as parent' do
              expect(controller.send(method, [:admin, user, post])).to include("/admin/users/#{user.id}/posts/#{post.id}")
            end
          end
        end
      end

      context 'with belongs_to multiple optional parents' do
        let(:user) { User.create! }
        let(:category) { Category.create! name: "Category" }
        let(:post) { Post.create! title: "Hello World", author: user, category: category }

        let(:post_config) do
          ActiveAdmin.register User
          ActiveAdmin.register Category
          ActiveAdmin.register Post do
            belongs_to :category, :user, optional: true
          end
        end

        %w(posts category_posts user_posts).each do |current_page|
          context "within the #{current_page} page" do
            let(:filter_param) { current_page.sub(/_?posts/, "").presence }
            let(:params) { filter_param ? { "#{filter_param}_id" => send(filter_param).id } : {} }

            it 'works with no parent' do
              expect(controller.send(method, [:admin, post])).to include("/admin/posts/#{post.id}")
            end

            it 'works with a user as parent' do
              expect(controller.send(method, [:admin, user, post])).to include("/admin/users/#{user.id}/posts/#{post.id}")
            end

            it 'works with a category as parent' do
              expect(controller.send(method, [:admin, category, post])).to include("/admin/categories/#{category.id}/posts/#{post.id}")
            end
          end
        end
      end
    end
  end
end
