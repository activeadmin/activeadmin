# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdminReset do
  it "restores a boot resource reconfigured without changing its controller name" do
    ActiveAdmin.register(Company) { config.filters = false }

    described_class.reset

    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).filters_enabled?).to be(true)
  end

  it "restores registrations rebuilt with the same controller and route names" do
    register_resources do
      ActiveAdmin.application.load!
      ActiveAdmin.register(Company) { config.filters = false }
    end

    described_class.reset

    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).filters_enabled?).to be(true)
  end

  it "restores a resource configuration changed without registering it again" do
    resource = ActiveAdmin.application.namespace(:admin).resource_for(Company)
    resource.filters = false

    described_class.reset

    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).filters_enabled?).to be(true)
  end

  it "restores settings after a boot namespace is removed" do
    application = ActiveAdmin.application
    application.namespaces.instance_variable_get(:@namespaces).delete(:admin)

    described_class.reset
    application.namespace(:admin).comments = false
    described_class.reset

    expect(application.namespace(:admin).comments).to be(true)
  end

  it "restores resources, menus and routes when a boot namespace is replaced" do
    application = ActiveAdmin.application
    original_menu_items = application.namespace(:admin).fetch_menu(:default).children.keys
    application.namespaces.instance_variable_get(:@namespaces).delete(:admin)
    replacement = application.namespace(:admin)
    replacement.comments = false
    replacement.register(Company) { config.filters = false }
    replacement.register(Post)
    replacement.build_menu { |menu| menu.add(label: "Temporary", url: "/temporary") }

    described_class.reset

    namespace = application.namespace(:admin)
    expect(namespace.comments).to be(true)
    expect(namespace.resource_for(Post)).to be_nil
    expect(namespace.resource_for(Company).controller).to eq(Admin::CompaniesController)
    expect(namespace.resource_for(Company).filters_enabled?).to be(true)
    expect(namespace.fetch_menu(:default).children.keys).to match_array(original_menu_items)
    expect(Rails.application.routes.url_helpers.admin_companies_path).to eq("/admin/companies")
  end

  it "restores application settings changed without the settings helper" do
    original = ActiveAdmin.application.site_title.dup
    ActiveAdmin.application.site_title = "Temporary title"

    described_class.reset

    expect(ActiveAdmin.application.site_title).to eq(original)
  end

  it "restores mutable strings changed in place" do
    original = ActiveAdmin.application.site_title.dup
    ActiveAdmin.application.site_title << " changed"

    described_class.reset

    expect(ActiveAdmin.application.site_title).to eq(original)
  end

  it "preserves frozen defaults and duplicates mutable nested values" do
    frozen_default = { title: ["Frozen".freeze].freeze }.freeze
    mutable_default = { title: ["Mutable"] }
    frozen_copy = described_class.send(:duplicate_setting, frozen_default)
    mutable_copy = described_class.send(:duplicate_setting, mutable_default)
    mutable_copy[:title] << " changed"

    expect(frozen_copy).to be_frozen
    expect(frozen_copy[:title]).to be_frozen
    expect(frozen_copy[:title].first).to be_frozen
    expect(mutable_default[:title]).to eq(["Mutable"])
    expect(mutable_copy[:title]).to eq(["Mutable", " changed"])
    expect(mutable_copy[:title]).not_to be_frozen
  end

  it "restores a typed setting writer after registration replaces it" do
    application = ActiveAdmin.application
    ActiveAdmin::NamespaceSettings.register(:site_title, "Temporary", :string_symbol_or_proc)

    described_class.reset

    sequence = 0
    application.site_title = proc { sequence += 1; "Title #{sequence}" }
    expect([application.site_title, application.site_title]).to eq(["Title 1", "Title 2"])
  end

  it "restores mutable application settings changed in place" do
    ActiveAdmin.application.csv_options[:col_sep] = ";"

    described_class.reset

    expect(ActiveAdmin.application.csv_options[:col_sep]).to eq(",")
  end

  it "removes settings registered on the base settings classes" do
    application = ActiveAdmin.application
    namespace = application.namespace(:admin)
    ActiveAdmin::Application.setting(:temporary_application_setting, "default")
    ActiveAdmin::Application.inheritable_setting(:temporary_namespace_setting, "default")
    application.temporary_application_setting = "changed"
    application.temporary_namespace_setting = "changed"
    namespace.temporary_namespace_setting = "changed again"

    described_class.reset

    expect(application).not_to respond_to(:temporary_application_setting)
    expect(application).not_to respond_to(:temporary_namespace_setting)
    expect(namespace).not_to respond_to(:temporary_namespace_setting)
    expect(ActiveAdmin::ApplicationSettings.instance_methods(false)).not_to include(:temporary_application_setting)
    expect(ActiveAdmin::NamespaceSettings.instance_methods(false)).not_to include(:temporary_namespace_setting_setting)

    ActiveAdmin::Application.setting(:temporary_application_setting, "new default")
    ActiveAdmin::Application.inheritable_setting(:temporary_namespace_setting, "new default")
    expect(application.temporary_application_setting).to eq("new default")
    expect(application.temporary_namespace_setting).to eq("new default")
    expect(namespace.temporary_namespace_setting).to eq("new default")
  end

  it "restores settings registered by authorization adapters" do
    application = ActiveAdmin.application
    application.cancan_ability_class = "TemporaryAbility"
    application.pundit_policy_namespace = :temporary

    described_class.reset

    expect(application.cancan_ability_class).to eq("Ability")
    expect(application.pundit_policy_namespace).to be_nil
  end

  it "removes modules created for temporary namespaces, including detached ones" do
    ActiveAdmin.application.namespace(:temporary_isolation_namespace)
    detached = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :detached_isolation_namespace)
    detached.register(Post)

    described_class.reset

    expect(Object.const_defined?(:TemporaryIsolationNamespace, false)).to be(false)
    expect(Object.const_defined?(:DetachedIsolationNamespace, false)).to be(false)
  end

  it "preserves a preexisting module used by a temporary namespace" do
    existing = stub_const("ExistingIsolationNamespace", Module.new)
    ActiveAdmin.application.namespace(:existing_isolation_namespace).register(Post)

    described_class.reset

    expect(Object.const_get(:ExistingIsolationNamespace, false)).to equal(existing)
    expect(existing.const_defined?(:PostsController, false)).to be(false)
  end

  context "when a namespace module is stubbed", order: :defined do
    it "registers resources in the stubbed namespace" do
      stub_const("StubbedCleanupNamespace", Module.new)
      namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :stubbed_cleanup_namespace)
      namespace.register(Post)
    end

    it "starts the next example with clean registration state" do
      expect(ActiveAdminReset.registering_namespaces).to be_empty
      expect(Object.const_defined?(:StubbedCleanupNamespace, false)).to be(false)
    end
  end

  it "restores route definitions when route names do not change" do
    namespace = ActiveAdmin.application.namespace(:admin)
    original_route_options = namespace.route_options
    namespace.route_options = { path: "/temporary" }
    Rails.application.reload_routes!

    expect(Rails.application.routes.url_helpers.admin_companies_path).to eq("/temporary/companies")
    namespace.route_options = original_route_options
    described_class.reset

    expect(Rails.application.routes.url_helpers.admin_companies_path).to eq("/admin/companies")
  end

  it "rejects shared controllers after restoring the app" do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register Company

    expect { described_class.reset }.to raise_error(ActiveAdminReset::SharedControllerError, /Admin::CompaniesController/)
    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).controller).to eq(Admin::CompaniesController)
  end
end
