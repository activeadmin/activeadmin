require 'rails_helper'

RSpec.describe ActiveAdmin::ResourceController::Sidebars, type: :controller do
  let(:klass){ Admin::PostsController }

  before do
    @controller = klass.new
  end

  context 'without skip_sidebar! before filter' do
    before do
      ActiveAdmin.register Post
      reload_routes!
    end

    it 'does not set @skip_sidebar' do
      get :index

      expect(controller.instance_variable_get(:@skip_sidebar)).to eq nil
    end
  end

  context 'with skip_sidebar! before_filter' do
    before do
      ActiveAdmin.register Post do
        before_filter :skip_sidebar!
      end
      reload_routes!
    end

    it 'works' do
      get :index

      expect(controller.instance_variable_get(:@skip_sidebar)).to eq true
    end
  end
end unless ActiveAdmin::Dependency.rails < 4
