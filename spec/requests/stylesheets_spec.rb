require 'rails_helper'

RSpec.describe "Stylesheets", type: :request do
  let(:application) { ActiveAdmin::Application.new }

  describe 'disabling use_webpacker flag' do
    before { application.use_webpacker = false }

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

  describe 'enabling use_webpacker flag' do
    before { application.use_webpacker = false }

    require "webpacker"

    if defined?(Webpack)
      let(:css) do
        assets = Webpack.load_entries(JSON.parse(File.read(Rails.root.join('webpack-assets.json'))))
        assets.find_asset("active_admin.css")
      end

      it "should successfully render the scss stylesheets using webpacker" do
        expect(css).to_not eq nil
      end

      it "should not have any syntax errors" do
        expect(css.to_s).to_not include("Syntax error:")
      end
    end
  end
end
