require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::Sidebars, type: :controller do
  let(:klass) { Admin::PostsController }

  shared_context 'with post config' do
    before do
      load_resources { post_config }

      @controller = klass.new

      get :index
    end
  end

  context 'without skip_sidebar! before filter' do
    include_context 'with post config' do
      let(:post_config) { ActiveAdmin.register Post }
    end

    it 'does not set @skip_sidebar' do
      expect(controller.instance_variable_get(:@skip_sidebar)).to eq nil
    end
  end

  context 'with skip_sidebar! before_action' do
    include_context 'with post config' do
      let(:post_config) do
        ActiveAdmin.register(Post) { before_action :skip_sidebar! }
      end
    end

    it 'works' do
      expect(controller.instance_variable_get(:@skip_sidebar)).to eq true
    end
  end
end
