require 'rails_helper'

RSpec.describe Admin::PostsController, 'Index overriding', type: :controller do
  before do
    load_defaults!
    # HACK: the AA config is missing, so we throw it in here
    controller.class.active_admin_config = ActiveAdmin.application.namespace(:admin).resources['Post'].controller.active_admin_config
  end

  context 'With passed block' do
    before do
      controller.instance_eval do
        def index
          super do
            render Dependency.rails.render_key => 'Rendered from passed block'
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

  context 'With passed options' do
    before do
      TestResponder = Class.new(ActionController::Responder) do
        def to_html
          render plain: 'Rendered from options'
        end
      end

      controller.instance_eval do
        def index
          super responder: TestResponder
        end
      end
    end

    it 'should pass along options to the overridden index' do
      get :index
      expect(response.body).to eq 'Rendered from options'
    end
  end

end
