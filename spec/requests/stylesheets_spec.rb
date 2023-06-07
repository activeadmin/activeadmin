# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Stylesheets", type: :request, unless: ActiveAdmin.application.use_webpacker do
  require "sprockets"

  let(:css) do
    assets = Rails.application.assets
    assets.find_asset("active_admin.css")
  end
  it "should successfully render the scss stylesheets using sprockets" do
    expect(css).to_not eq nil
  end

  it "should not have any syntax errors" do
    expect(css.to_s).to_not include("Syntax error:")
  end
end
