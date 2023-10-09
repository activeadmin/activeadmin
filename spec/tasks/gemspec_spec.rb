# frozen_string_literal: true
require "open3"
require "active_admin/version"

RSpec.describe "gemspec sanity" do
  after do
    File.delete("activeadmin-#{ActiveAdmin::VERSION}.gem")
  end

  let(:build) do
    Open3.capture3("gem build activeadmin.gemspec")
  end

  it "succeeds" do
    expect(build[2]).to be_success
  end
end
