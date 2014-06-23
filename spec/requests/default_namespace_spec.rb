require 'rails_helper'

describe ActiveAdmin::Application, :type => :request do

  include Rails.application.routes.url_helpers

  [false, nil].each do |value|

    describe "with a #{value} default namespace" do

      before(:all) do
        @__original_application = ActiveAdmin.application
        application = ActiveAdmin::Application.new
        application.default_namespace = value
        ActiveAdmin.application = application
        load_defaults!
        reload_routes!
      end

      after(:all) do
        ActiveAdmin.application = @__original_application
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

      before(:all) do
        @__original_application = ActiveAdmin.application
        application = ActiveAdmin::Application.new
        application.default_namespace = :test
        ActiveAdmin.application = application
        load_defaults!
        reload_routes!
      end

      after(:all) do
        ActiveAdmin.application = @__original_application
      end

      it "should generate a log out path" do
        expect(destroy_admin_user_session_path).to eq "/test/logout"
      end

      it "should generate a log in path" do
        expect(new_admin_user_session_path).to eq "/test/login"
      end

    end

end
