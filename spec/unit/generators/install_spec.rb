require "rails_helper"
require "generators/active_admin/install/install_generator"

class ActiveAdmin::Generators::InstallGenerator
  attr_reader :name, :use_authentication_method
end

RSpec.describe ActiveAdmin::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp/test_apps/generator_samples", __dir__)
  before { prepare_destination }

  context "interactive setup" do
    it "sets control variables correctly with skip-users option" do
      gen = generator %w[--skip-users]
      invoke_task :interactive_setup

      expect(gen.use_authentication_method).to be false
    end

    it "sets control variables to default with no_interation option" do
      gen = generator %w[--no_interaction]
      invoke_task :interactive_setup

      expect(gen.name).to eql "AdminUser"
      expect(gen.use_authentication_method).to be true
    end

    it "skips interaction when name argument is passed" do
      gen = generator %w[CustomAdmin]
      invoke_task :interactive_setup

      expect(gen.name).to eql "CustomAdmin"
      expect(gen.use_authentication_method).to be true
    end

    it "sets control variables correctly when user answers NO to auth with Devise" do
      gen = generator
      allow(gen).to receive(:yes?) { false }

      invoke_task :interactive_setup

      expect(gen.use_authentication_method).to be false
    end

    it "sets control variables correctly when user answers the admin class name" do
      gen = generator
      allow(gen).to receive(:yes?) { true }
      allow(gen).to receive(:ask) { "CustomAdmin" }

      invoke_task :interactive_setup

      expect(gen.name).to eql "CustomAdmin"
      expect(gen.use_authentication_method).to be true
    end

    it "sets control variables correctly when user hits ENTER on the admin class name question" do
      gen = generator
      allow(gen).to receive(:yes?) { true }
      allow(gen).to receive(:ask) { "" }

      invoke_task :interactive_setup

      expect(gen.name).to eql "AdminUser"
      expect(gen.use_authentication_method).to be true
    end
  end

  it "#copy_initializer" do
    invoke_task :copy_initializer

    path = Rails.root + "config/initializers/active_admin.rb"
    expect(File.exist?(path)).to be true
  end

  it "#setup_directory" do
    gen = generator %w[CustomAdmin]
    invoke_task :interactive_setup
    invoke_task :setup_directory

    path = Rails.root + "app/admin/dashboard.rb"
    expect(File.exist?(path)).to be true
  end

  context "#create_assets" do
    before { invoke_task :create_assets }

    it "active_admin.scss" do
      path = if ActiveAdmin.application.use_webpacker
               Rails.root + "app/javascript/stylesheets/active_admin.scss"
             else
               Rails.root + "app/assets/stylesheets/active_admin.scss"
             end
      expect(File.exist?(path)).to eq true
    end

    it "active_admin.js" do
      path = if ActiveAdmin.application.use_webpacker
               Rails.root + "app/javascript/packs/active_admin.js"
             else
               Rails.root + "app/assets/javascripts/active_admin.js"
             end
      expect(File.exist?(path)).to eq true
    end
  end
end
