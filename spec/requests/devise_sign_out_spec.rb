# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Signing out of ActiveAdmin", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin_user) { AdminUser.create!(email: "sign-out@example.com", password: "password", password_confirmation: "password") }

  before { sign_in admin_user }

  it "redirects to ActiveAdmin's root" do
    delete "/admin/logout"

    expect(response).to redirect_to("/admin")
  end

  context "when the app defines after_sign_out_path_for" do
    around do |example|
      ApplicationController.define_method(:after_sign_out_path_for) { |_scope| "/goodbye" }
      example.run
    ensure
      ApplicationController.remove_method(:after_sign_out_path_for)
    end

    it "keeps the app's redirect" do
      delete "/admin/logout"

      expect(response).to redirect_to("/goodbye")
    end
  end
end
