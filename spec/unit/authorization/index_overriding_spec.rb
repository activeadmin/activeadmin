require 'rails_helper'

RSpec.describe 'Index overriding', type: :controller do
  before do
    load_resources { ActiveAdmin.register Post }
    @controller = Admin::PostsController.new

    @controller.instance_eval do
      def index
        super do
          render ActiveAdmin::Dependency.rails.render_key => 'Rendered from passed block'
          return
        end
      end
    end
  end

  it 'should call block passed to overridden index' do
    get :index
    expect(response.body).to eq 'Rendered from passed block'
  end

end
