require 'spec_helper'

describe ActiveAdmin::Sass::Helpers do

  include ActiveAdmin::Sass::Helpers

  context "when not using the asset pipeline" do

    before(:all)do
      @actual_rails_version = Rails::VERSION::MINOR
      silence_warnings { Rails::VERSION::MINOR = 0 }
    end

    after(:all) do
      silence_warnings { Rails::VERSION::MINOR = @actual_rails_version }
    end

    it "should generate an image asset path to /images/active_admin" do
      active_admin_image_path(Sass::Script::String.new('test.jpg')).should ==
          Sass::Script::String.new("/images/active_admin/test.jpg", true)
    end

  end

  context "when using the asset pipeline" do
    before(:all)do
      @actual_rails_version = Rails::VERSION::MINOR
      silence_warnings { Rails::VERSION::MINOR = 1 }
    end

    after(:all) do
      silence_warnings { Rails::VERSION::MINOR = @actual_rails_version }
    end

    before do
      assets = mock(:enabled => true)
      Rails.application.config.stub!(:assets => assets)
    end

    it "should call the sass-rails asset helper" do
      self.should_receive(:asset_path).with(Sass::Script::String.new("active_admin/test.jpg"), Sass::Script::String.new('image'))
      active_admin_image_path(::Sass::Script::String.new('test.jpg'))
    end

  end

end
