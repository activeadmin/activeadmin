require 'rails_helper'

describe "Stylesheets", :type => :request do

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
