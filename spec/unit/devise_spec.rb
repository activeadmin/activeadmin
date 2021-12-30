# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Devise::Controller do
  let(:controller_class) do
    klass = Class.new do
      def self.layout(*); end
      def self.helper(*); end
    end
    klass.send(:include, ActiveAdmin::Devise::Controller)
    klass
  end

  let(:controller) { controller_class.new }
  let(:action_controller_config) { Rails.configuration.action_controller }

  def with_temp_relative_url_root(relative_url_root)
    previous_relative_url_root = action_controller_config[:relative_url_root]
    action_controller_config[:relative_url_root] = relative_url_root

    yield
  ensure
    action_controller_config[:relative_url_root] = previous_relative_url_root
  end

  context "with a RAILS_RELATIVE_URL_ROOT set" do
    around do |example|
      with_temp_relative_url_root("/foo") { example.call }
    end

    it "should set the root path to the default namespace" do
      expect(controller.root_path).to eq "/foo/admin"
    end

    it "should set the root path to '/' when no default namespace" do
      allow(ActiveAdmin.application).to receive(:default_namespace).and_return(false)
      expect(controller.root_path).to eq "/foo/"
    end
  end

  context "without a RAILS_RELATIVE_URL_ROOT set" do
    around do |example|
      with_temp_relative_url_root(nil) { example.call }
    end

    it "should set the root path to the default namespace" do
      expect(controller.root_path).to eq "/admin"
    end

    it "should set the root path to '/' when no default namespace" do
      allow(ActiveAdmin.application).to receive(:default_namespace).and_return(false)
      expect(controller.root_path).to eq "/"
    end
  end

  context "within a scoped route" do
    SCOPE = "/aa_scoped"

    before do
      # Remove existing routes
      routes = Rails.application.routes
      routes.clear!

      # Add scoped routes
      routes.draw do
        scope path: SCOPE do
          ActiveAdmin.routes(self)
          devise_for :admin_users, ActiveAdmin::Devise.config
        end
      end
    end

    after do
      # Resume default routes
      reload_routes!
    end

    it "should include scope path in root_path" do
      expect(controller.root_path).to eq "#{SCOPE}/admin"
    end
  end

  describe "#config" do
    let(:config) { ActiveAdmin::Devise.config }

    describe ":sign_out_via option" do
      it "should contain the application.logout_link_method" do
        expect(::Devise).to receive(:sign_out_via).and_return(:delete)
        expect(ActiveAdmin.application).to receive(:logout_link_method).and_return(:get)

        expect(config[:sign_out_via]).to include(:get)
      end

      it "should contain Devise's logout_via_method(s)" do
        expect(::Devise).to receive(:sign_out_via).and_return([:delete, :post])
        expect(ActiveAdmin.application).to receive(:logout_link_method).and_return(:get)

        expect(config[:sign_out_via]).to eq [:delete, :post, :get]
      end
    end # describe ":sign_out_via option"
  end # describe "#config"
end
