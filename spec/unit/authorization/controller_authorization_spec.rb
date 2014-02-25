require 'spec_helper'
Auth = ActiveAdmin::Authorization

describe Admin::PostsController, "Controller Authorization", type: :controller do

  let(:authorization){ controller.send(:active_admin_authorization) }

  before do
    load_defaults!
    # HACK: the AA config is missing, so we throw it in here
    controller.class.active_admin_config = ActiveAdmin.application.namespace(:admin).resources['Post'].controller.active_admin_config
  end

  it "should authorize the index action" do
    expect(authorization).to receive(:authorized?).with(Auth::READ, Post).and_return true
    get :index
    expect(response).to be_success
  end

  it "should authorize the new action" do
    expect(authorization).to receive(:authorized?).with(Auth::CREATE, an_instance_of(Post)).and_return true
    get :new
    expect(response).to be_success
  end

  it "should authorize the create action with the new resource" do
    expect(authorization).to receive(:authorized?).with(Auth::CREATE, an_instance_of(Post)).and_return true
    post :create
    expect(response).to redirect_to action: 'show', id: Post.last.id
  end

  it "should redirect when the user isn't authorized" do
    expect(authorization).to receive(:authorized?).with(Auth::READ, Post).and_return false
    get :index
    expect(response.body).to eq '<html><body>You are being <a href="http://test.host/admin">redirected</a>.</body></html>'
    expect(response).to redirect_to '/admin'
  end

end
