# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdminReset do
  it "restores a boot resource reconfigured without changing its controller name" do
    ActiveAdmin.register(Company) { config.filters = false }

    described_class.reset

    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).filters_enabled?).to be(true)
  end

  it "restores registrations rebuilt with the same controller and route names" do
    load_resources do
      ActiveAdmin.application.load!
      ActiveAdmin.register(Company) { config.filters = false }
    end

    described_class.reset

    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).filters_enabled?).to be(true)
  end

  it "rejects shared controllers after restoring the app" do
    namespace = ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin)
    namespace.register Company

    expect { described_class.reset }.to raise_error(ActiveAdminReset::SharedControllerError, /Admin::CompaniesController/)
    expect(ActiveAdmin.application.namespace(:admin).resource_for(Company).controller).to eq(Admin::CompaniesController)
  end
end
