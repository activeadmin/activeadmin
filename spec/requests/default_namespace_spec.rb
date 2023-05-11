# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Application, type: :request do
  let(:resource) { ActiveAdmin.register Category }

  [false, nil].each do |value|
    describe "with a #{value} default namespace" do
      around do |example|
        with_custom_default_namespace(value) { example.call }
      end

      it "should generate resource paths" do
        expect(resource.route_collection_path).to eq "/categories"
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
      with_custom_default_namespace(:test) { example.call }
    end

    it "should generate resource paths" do
      expect(resource.route_collection_path).to eq "/test/categories"
    end

    it "should generate a log out path" do
      expect(destroy_admin_user_session_path).to eq "/test/logout"
    end

    it "should generate a log in path" do
      expect(new_admin_user_session_path).to eq "/test/login"
    end
  end

  describe "with a namespace with underscores in the name" do
    around do |example|
      with_custom_default_namespace(:abc_123) { example.call }
    end

    it "should generate resource paths" do
      expect(resource.route_collection_path).to eq "/abc_123/categories"
    end

    it "should generate a log out path" do
      expect(destroy_admin_user_session_path).to eq "/abc_123/logout"
    end

    it "should generate a log in path" do
      expect(new_admin_user_session_path).to eq "/abc_123/login"
    end
  end

  private

  def with_custom_default_namespace(namespace)
    application = ActiveAdmin::Application.new
    application.default_namespace = namespace

    with_temp_application(application) { yield }
  end

  def with_temp_application(application)
    original_application = ActiveAdmin.application
    ActiveAdmin.application = application

    load_resources { ActiveAdmin.register(Category) }

    yield

  ensure
    ActiveAdmin.application = original_application
  end
end
