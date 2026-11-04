# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Helpers::Routes do
  it "delegates route helpers to ActiveAdmin's route set" do
    expect(described_class.admin_root_path).to eq "/admin"
  end

  it "raises NoMethodError for a method the route set does not define" do
    expect(described_class).not_to respond_to(:no_such_path)
    expect { described_class.no_such_path }.to raise_error(NoMethodError)
  end

  it "uses the default URL options of ActiveAdmin's route set" do
    route_set = ActionDispatch::Routing::RouteSet.new
    route_set.default_url_options = { host: "admin.example.com" }
    allow(ActiveAdmin.application).to receive(:route_set).and_return(route_set)

    expect(described_class.default_url_options).to eq(host: "admin.example.com")
  end
end
