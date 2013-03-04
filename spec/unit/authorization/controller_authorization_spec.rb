require 'spec_helper'

describe Admin::PostsController, "Controller Authorization", :type => :controller do

  let(:user) { AdminUser.create!(:email => "example@admin.com", :password => "password", :password_confirmation => "password") }
  let(:app) { ActiveAdmin.application }
  let(:authorization){ controller.send(:active_admin_authorization) }

  before do
  # TODO: Get these tests passing...
    pending

    load_defaults!
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @resource.namespace.current_user_method = :current_admin_user

    sign_in(user)
  end

  it "should authorize the index action" do
    authorization.should_receive(:authorized?).
      with(ActiveAdmin::Authorization::READ, Post).
      and_return(true)

    get :index
  end

  it "should authorize the new action" do
    authorization.should_receive(:authorized?).
      with(ActiveAdmin::Authorization::CREATE, an_instance_of(Post)).
      and_return(true)

    get :new
  end

  it "should authorize the create action with the new resource" do
    mock_post = mock("Post", :save => true, :errors => [])
    Post.should_receive(:new).at_least(:once).and_return(mock_post)

    authorization.should_receive(:authorized?).
      with(ActiveAdmin::Authorization::CREATE, mock_post).
      and_return(true)

    post :create
  end

end
