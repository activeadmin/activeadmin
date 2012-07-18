require 'spec_helper'

describe "Controller Authorization", :type => :controller do

  let(:user) { AdminUser.create!(:email => "example@admin.com", :password => "password", :password_confirmation => "password") }
  let(:app) { ActiveAdmin::Application.new }
  let(:resource) { app.register(Post) }
  let(:controller) { resource.controller.new }
  let(:authorization){ controller.send(:active_admin_authorization) }

  before do
    @controller = controller
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    resource.namespace.current_user_method = :current_admin_user
    sign_in(user)
  end

  it "should authorize the index action" do
    authorization.should_receive(:authorized?).
      with(user, ActiveAdmin::Authorization::READ, Post).
      and_return(true)

    get :index
  end

  it "should authorize the new action" do
    authorization.should_receive(:authorized?).
      with(user, ActiveAdmin::Authorization::CREATE, an_instance_of(Post)).
      and_return(true)

    get :new
  end

  it "should authorize the create action with the new resource" do
    mock_post = mock("Post", :save => true, :errors => [])
    Post.should_receive(:new).at_least(:once).and_return(mock_post)

    authorization.should_receive(:authorized?).
      with(user, ActiveAdmin::Authorization::CREATE, mock_post).
      and_return(true)

    post :create
  end

end
