require 'rails_helper'

RSpec.describe ActiveAdmin::Application, type: :request do

  include Rails.application.routes.url_helpers

  [false, nil].each do |value|

    describe "with a #{value} default namespace" do

      around do |example|
        application = ActiveAdmin::Application.new
        application.default_namespace = value

        with_temp_application(application) { example.call }
      end

      it "should generate a log out path" do
        expect(destroy_admin_user_session_path).to eq "/logout"
      end

      it "should generate a log in path" do
        expect(new_admin_user_session_path).to eq "/login"
      end

    end

  end

  describe "with a test default namespace" do

    around do |example|
      application = ActiveAdmin::Application.new
      application.default_namespace = :test

      with_temp_application(application) { example.call }
    end

    it "should generate a log out path" do
      expect(destroy_admin_user_session_path).to eq "/test/logout"
    end

    it "should generate a log in path" do
      expect(new_admin_user_session_path).to eq "/test/login"
    end

  end

end
