require 'spec_helper'
Auth = ActiveAdmin::Authorization

describe Admin::PostsController, "Controller Authorization", :type => :controller do

  let(:authorization){ controller.send(:active_admin_authorization) }

  before do
    load_defaults!
    # HACK: the AA config is missing, so we throw it in here
    controller.class.active_admin_config = ActiveAdmin.application.namespace(:admin).resources['Post'].controller.active_admin_config
  end

  it "should authorize the index action" do
    authorization.should_receive(:authorized?).with(Auth::READ, Post).and_return true
    get :index
    response.should be_success
  end

  it "should authorize the new action" do
    authorization.should_receive(:authorized?).with(Auth::CREATE, an_instance_of(Post)).and_return true
    get :new
    response.should be_success
  end

  it "should authorize the create action with the new resource" do
    authorization.should_receive(:authorized?).with(Auth::CREATE, an_instance_of(Post)).and_return true
    post :create
    response.should redirect_to action: 'show', id: Post.last.id
  end

  it "should redirect when the user isn't authorized" do
    authorization.should_receive(:authorized?).with(Auth::READ, Post).and_return false
    get :index
    response.body.should eq '<html><body>You are being <a href="http://test.host/admin">redirected</a>.</body></html>'
    response.should redirect_to '/admin'
  end

end
