require 'rails_helper'

describe Admin::PostsController, 'Index overriding', type: :controller do
  before do
    controller.instance_eval do
      def index
        super do
          render Dependency.rails.render_key => 'Rendered from passed block'
          return
        end
      end
    end
    load_defaults!
    # HACK: the AA config is missing, so we throw it in here
    controller.class.active_admin_config = ActiveAdmin.application.namespace(:admin).resources['Post'].controller.active_admin_config
  end

  it 'should call block passed to overridden index' do
    get :index
    expect(response.body).to eq 'Rendered from passed block'
  end

end
