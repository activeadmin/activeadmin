# frozen_string_literal: true
require "rails_helper"

module EngineRoutesSpec
  class Engine < ::Rails::Engine
  end
end

RSpec.describe "ActiveAdmin routes drawn in an engine", type: :request do
  let(:engine_routes) { EngineRoutesSpec::Engine.routes }

  around do |example|
    ActiveAdmin.unload!
    # Draw the host routes first: drawing a lazy route set loads
    # config/routes.rb, which calls ActiveAdmin.routes on the host set.
    Rails.application.routes.draw do
      mount EngineRoutesSpec::Engine => "/backoffice", as: :backoffice
    end
    engine_routes.draw do
      devise_for :admin_users, ActiveAdmin::Devise.config.merge(router_name: :backoffice)
      ActiveAdmin.routes(self)
    end

    example.run
  ensure
    ActiveAdmin.unload!
    Rails.application.reload_routes!
  end

  it "keeps the engine's route set" do
    expect(ActiveAdmin.application.route_set).to equal(engine_routes)
  end

  it "builds resource paths from the engine's route set" do
    resource = ActiveAdmin.application.namespace(:admin).resource_for(AdminUser)

    expect(resource.route_collection_path).to eq "/backoffice/admin/admin_users"
  end

  it "renders resource pages with links into the engine" do
    get "/backoffice/admin/admin_users"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('href="/backoffice/admin/admin_users/new"')
  end

  describe "Devise sessions" do
    include Devise::Test::IntegrationHelpers

    let!(:admin_user) { AdminUser.create!(email: "engine@example.com", password: "password", password_confirmation: "password") }

    it "signs in and redirects to the engine's admin root" do
      post "/backoffice/admin/login", params: { admin_user: { email: admin_user.email, password: "password" } }

      expect(response).to redirect_to("/backoffice/admin")
    end

    it "redirects a signed-in user away from the login page" do
      sign_in admin_user
      get "/backoffice/admin/login"

      expect(response).to redirect_to("/backoffice/admin")
    end

    it "signs out and redirects to the engine's admin root" do
      sign_in admin_user
      delete "/backoffice/admin/logout"

      expect(response).to redirect_to("/backoffice/admin")
    end
  end

  it "renders the Devise login form with the engine's session path" do
    get "/backoffice/admin/login"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include('action="/backoffice/admin/login"')
  end
end

RSpec.describe "ActiveAdmin routes drawn in the application" do
  it "uses the application's route set" do
    expect(ActiveAdmin.application.route_set).to equal(Rails.application.routes)
  end
end
