require 'spec_helper'

describe ActiveAdmin::Application do

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
        destroy_admin_user_session_path.should == "/admin_users/logout"
      end

      it "should generate a log in path" do
        new_admin_user_session_path.should == "/admin_users/login"
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
        destroy_admin_user_session_path.should == "/test/logout"
      end

      it "should generate a log in path" do
        new_admin_user_session_path.should == "/test/login"
      end

    end

end
