# frozen_string_literal: true
require "rails_helper"
require "fileutils"

RSpec.describe ActiveAdmin::Application do
  let(:application) { ActiveAdmin::Application.new }

  it "should have a default load path of ['app/admin']" do
    expect(application.load_paths).to eq [File.expand_path("app/admin", application.app_path)]
  end

  describe "#prepare" do
    before { application.prepare! }

    it "should remove app/admin from the autoload paths" do
      expect(ActiveSupport::Dependencies.autoload_paths).to_not include(Rails.root.join("app/admin"))
    end
  end

  it "should store the site's title" do
    expect(application.site_title).to eq ""
  end

  it "should set the site title" do
    application.site_title = "New Title"
    expect(application.site_title).to eq "New Title"
  end

  it "should set the site title using a block" do
    application.site_title = proc { "Block Title" }
    expect(application.site_title).to eq "Block Title"
  end

  it "should return default localize format" do
    expect(application.localize_format).to eq :long
  end

  it "should set localize format" do
    application.localize_format = :default
    expect(application.localize_format).to eq :default
  end

  it "should allow comments by default" do
    expect(application.comments).to eq true
  end

  it "should have default order clause class" do
    expect(application.order_clause).to eq ActiveAdmin::OrderClause
  end

  it "should have default show_count for scopes" do
    expect(application.scopes_show_count).to eq true
  end

  it "fails if setting undefined" do
    expect do
      application.undefined_setting
    end.to raise_error(NoMethodError)
  end

  describe "authentication settings" do
    it "should have no default current_user_method" do
      expect(application.current_user_method).to eq false
    end

    it "should have no default authentication method" do
      expect(application.authentication_method).to eq false
    end

    it "should have a logout link path (Devise's default)" do
      expect(application.logout_link_path).to eq :destroy_admin_user_session_path
    end
  end

  describe "files in load path" do
    it "it should load sorted files" do
      expect(application.files.map { |f| File.basename(f) }).to eq %w(admin_users.rb companies.rb dashboard.rb profiles.rb stores.rb)
    end

    it "should load files in the first level directory" do
      expect(application.files).to include(File.expand_path("app/admin/dashboard.rb", application.app_path))
    end

    it "should load files from subdirectories", :changes_filesystem do
      test_dir = File.expand_path("app/admin/public", application.app_path)
      test_file = File.expand_path("app/admin/public/posts.rb", application.app_path)

      begin
        FileUtils.mkdir_p(test_dir)
        FileUtils.touch(test_file)
        expect(application.files).to include(test_file)
      ensure
        FileUtils.remove_entry_secure(test_dir, force: true)
      end
    end

    it "should honor load paths order", :changes_filesystem do
      test_dir = File.expand_path("app/other-admin", application.app_path)
      test_file = File.expand_path("app/other-admin/posts.rb", application.app_path)

      application.load_paths.unshift(test_dir)

      begin
        FileUtils.mkdir_p(test_dir)
        FileUtils.touch(test_file)
        expect(application.files.map { |f| File.basename(f) }).to(
          eq(%w(posts.rb admin_users.rb companies.rb dashboard.rb profiles.rb stores.rb))
        )
      ensure
        FileUtils.remove_entry_secure(test_dir, force: true)
      end
    end
  end

  describe "#namespace" do
    it "should yield a new namespace" do
      application.namespace :new_namespace do |ns|
        expect(ns.name).to eq :new_namespace
      end
    end

    it "should return an instantiated namespace" do
      admin = application.namespace :admin
      expect(admin).to eq application.namespaces[:admin]
    end

    it "should yield an existing namespace" do
      expect do
        application.namespace :admin do |ns|
          expect(ns).to eq application.namespaces[:admin]
          raise "found"
        end
      end.to raise_error("found")
    end

    it "should admit both strings and symbols" do
      expect do
        application.namespace "admin" do |ns|
          expect(ns).to eq application.namespaces[:admin]
          raise "found"
        end
      end.to raise_error("found")
    end

    it "should not pollute the global app" do
      expect(application.namespaces).to be_empty
      application.namespace(:brand_new_ns)
      expect(application.namespaces.names).to eq [:brand_new_ns]
      expect(ActiveAdmin.application.namespaces.names).to eq [:admin]
    end
  end

  describe "#register_page" do
    it "finds or create the namespace and register the page to it" do
      namespace = double
      expect(application).to receive(:namespace).with("public").and_return namespace
      expect(namespace).to receive(:register_page).with("My Page", { namespace: "public" })
      application.register_page("My Page", namespace: "public")
    end
  end
end
