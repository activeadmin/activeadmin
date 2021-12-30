# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Registering an object to administer" do
  let(:application) { ActiveAdmin::Application.new }

  context "with no configuration" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }

    before do
      application.namespaces[namespace.name] = namespace
    end

    it "should call register on the namespace" do
      expect(namespace).to receive(:register)

      application.register Category
    end

    it "should dispatch a Resource::RegisterEvent" do
      expect(ActiveSupport::Notifications).to receive(:publish).with(ActiveAdmin::Resource::RegisterEvent, an_instance_of(ActiveAdmin::Resource))

      application.register Category
    end
  end

  context "with a different namespace" do
    it "should call register on the namespace" do
      namespace = ActiveAdmin::Namespace.new(application, :hello_world)
      application.namespaces[namespace.name] = namespace
      expect(namespace).to receive(:register)

      application.register Category, namespace: :hello_world
    end

    it "should generate a Namespace::RegisterEvent and a Resource::RegisterEvent" do
      expect(ActiveSupport::Notifications).to receive(:publish).with(ActiveAdmin::Namespace::RegisterEvent, an_instance_of(ActiveAdmin::Namespace))
      expect(ActiveSupport::Notifications).to receive(:publish).with(ActiveAdmin::Resource::RegisterEvent, an_instance_of(ActiveAdmin::Resource))
      application.register Category, namespace: :not_yet_created
    end
  end

  context "with no namespace" do
    it "should call register on the root namespace" do
      namespace = ActiveAdmin::Namespace.new(application, :root)
      application.namespaces[namespace.name] = namespace
      expect(namespace).to receive(:register)

      application.register Category, namespace: false
    end
  end

  context "when being registered multiple times" do
    it "should run the dsl in the same config object" do
      config_1 = ActiveAdmin.register(Category) { filter :name }
      config_2 = ActiveAdmin.register(Category) { filter :id }
      expect(config_1).to eq config_2
      expect(config_1.filters.size).to eq 2
    end
  end
end
