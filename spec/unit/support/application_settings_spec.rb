# frozen_string_literal: true
require "rails_helper"

RSpec.describe ApplicationSettingsHelper do
  let(:application) { ActiveAdmin::Application.new }

  before { allow(ActiveAdmin).to receive(:application).and_return(application) }

  it "restores a dynamic setting without evaluating its Proc" do
    sequence = 0
    application.site_title = proc { sequence += 1; "Title #{sequence}" }

    set_application_setting(:site_title, "Temporary")
    restore_application_settings

    expect([application.site_title, application.site_title]).to eq(["Title 1", "Title 2"])
  end

  it "restores an inherited namespace setting so later application changes reach it" do
    namespace = application.namespace(:test)
    set_namespace_setting(:test, :maximum_association_filter_arity, 3)
    restore_application_settings

    application.maximum_association_filter_arity = 7

    expect(namespace.maximum_association_filter_arity).to eq(7)
  end

  it "preserves a namespace's own override" do
    namespace = application.namespace(:test)
    namespace.maximum_association_filter_arity = 4
    set_namespace_setting(:test, :maximum_association_filter_arity, 3)
    restore_application_settings

    application.maximum_association_filter_arity = 7

    expect(namespace.maximum_association_filter_arity).to eq(4)
  end

  it "restores the original setting after several changes" do
    application.site_title = "Original"
    set_application_setting(:site_title, "First")
    set_application_setting(:site_title, "Second")
    restore_application_settings

    expect(application.site_title).to eq("Original")
  end

  it "restores both application and namespace settings without losing inheritance" do
    namespace = application.namespace(:test)
    set_application_setting(:maximum_association_filter_arity, 5)
    set_namespace_setting(:test, :maximum_association_filter_arity, 3)
    restore_application_settings

    expect(application.maximum_association_filter_arity).to eq(:unlimited)
    application.maximum_association_filter_arity = 7
    expect(namespace.maximum_association_filter_arity).to eq(7)
  end
end
