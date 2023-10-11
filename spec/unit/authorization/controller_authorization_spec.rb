# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Controller Authorization", type: :controller do
  let(:authorization) { controller.send(:active_admin_authorization) }

  before do
    load_resources { ActiveAdmin.register Post }
    @controller = Admin::PostsController.new
    allow(authorization).to receive(:authorized?)
  end

  it "should authorize the index action" do
    expect(authorization).to receive(:authorized?).with(auth::READ, Post).and_return true
    get :index
    expect(response).to be_successful
  end

  it "should authorize the new action" do
    expect(authorization).to receive(:authorized?).with(auth::NEW, an_instance_of(Post)).and_return true
    get :new
    expect(response).to be_successful
  end

  it "should authorize the create action with the new resource" do
    expect(authorization).to receive(:authorized?).with(auth::CREATE, an_instance_of(Post)).and_return true
    post :create
    expect(response).to redirect_to action: "show", id: Post.last.id
  end

  it "should redirect when the user isn't authorized" do
    expect(authorization).to receive(:authorized?).with(auth::READ, Post).and_return false
    get :index

    expect(response).to redirect_to "/admin"
  end

  private

  def auth
    ActiveAdmin::Authorization
  end
end
