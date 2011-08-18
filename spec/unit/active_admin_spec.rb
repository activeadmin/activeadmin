require 'spec_helper'

describe ActiveAdmin do
  describe "#default_namespace" do
    it "should delegate to ActiveAdmin.application" do
      ActiveAdmin.application.should_receive(:default_namespace)

      ActiveAdmin.default_namespace
    end

    it "should be deprecated" do
      ActiveAdmin::Deprecation.should_receive(:warn)

      ActiveAdmin.default_namespace
    end
  end
end
