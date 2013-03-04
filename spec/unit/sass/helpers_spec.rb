require 'spec_helper'

describe ActiveAdmin::Sass::Helpers do

  include ActiveAdmin::Sass::Helpers

  context "when not using the asset pipeline" do

    before(:each) do
      @orig_rails_app = Rails.application.dup
    end

    after(:each) do
      Rails.application = @orig_rails_app
    end

    it "should generate an image asset path to /images/active_admin" do
      assets = mock(:enabled => false)
      Rails.application.config.stub!(:assets => assets)
      active_admin_image_path(Sass::Script::String.new('test.jpg')).should ==
          Sass::Script::String.new("/images/active_admin/test.jpg", true)
    end

  end

  context "when using the asset pipeline" do
    before(:each) do
      @orig_rails_app = Rails.application.dup
    end

    after(:each) do
      Rails.application = @orig_rails_app
    end

    it "should call the sass-rails asset helper" do
      assets = mock(:enabled => true)
      Rails.application.config.stub!(:assets => assets)
      self.should_receive(:asset_path).with(Sass::Script::String.new("active_admin/test.jpg"), Sass::Script::String.new('image'))
      active_admin_image_path(::Sass::Script::String.new('test.jpg'))
    end

  end

end
