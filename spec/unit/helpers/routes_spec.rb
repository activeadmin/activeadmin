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

  it "uses the route set's default URL options" do
    expect(described_class.default_url_options).to eq(Rails.application.routes.default_url_options)
  end
end
