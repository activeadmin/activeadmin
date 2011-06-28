require 'spec_helper'

describe "Stylesheets" do
  if Rails.version[0..2] == '3.1'
    require "sprockets"
    context "when Rails 3.1.x" do
      let(:css) do
        assets = Rails.application.assets
        assets.find_asset("active_admin.css")
      end
      it "should successfully render the scss stylesheets using sprockets" do
        css.should_not be_nil
      end
      it "should not have any syntax errors" do
        css.to_s.should_not include("Syntax error:")
      end
    end
  end

  if Rails.version[0..2] == '3.0'
    context "when Rails 3.0.x" do
      let(:stylesheet_path) do
        Rails.root + 'public/stylesheets/active_admin.css'
      end

      before do
        "rm #{stylesheet_path}" if File.exists?(stylesheet_path)
        Sass::Plugin.force_update_stylesheets
      end

      it "should render the scss stylesheets using SASS" do
        File.exists?(stylesheet_path).should be_true
      end

      it "should not have any syntax errors" do
        css = File.read(stylesheet_path)
        css.should_not include("Syntax error:")
      end
    end
  end
end
