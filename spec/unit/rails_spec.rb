require 'spec_helper'

describe ActiveAdmin do

  describe "use_asset_pipeline?" do

    before(:each) do
      @orig_rails_version = Rails::VERSION::MINOR
    end

    after(:each) do
      silence_warnings { Rails::VERSION::MINOR = @orig_rails_version }
    end

    it "should be false when using rails 3.0.x" do
      silence_warnings { Rails::VERSION::MINOR = 0 }
      ActiveAdmin.use_asset_pipeline?.should be_false
    end

    context "when rails 3.1.x" do
      before(:each) do
        @orig_rails_app = Rails.application.dup
        silence_warnings { Rails::VERSION::MINOR = 1 }
      end

      after(:each) do
        Rails.application = @orig_rails_app
      end

      it "should be false without asset pipeline enabled" do
        assets = mock(:enabled => false)
        Rails.application.config.stub!(:assets => assets)
        ActiveAdmin.use_asset_pipeline?.should be_false
      end

      it "should be true with asset pipeline enabled" do
        assets = mock(:enabled => true)
        Rails.application.config.stub!(:assets => assets)
        ActiveAdmin.use_asset_pipeline?.should be_true
      end
    end
  end
end
