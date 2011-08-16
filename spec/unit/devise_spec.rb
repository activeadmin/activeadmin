require 'spec_helper'

describe ActiveAdmin::Devise::Controller do

  let(:controller_class) do
    klass = Class.new do
      def self.layout(*); end
      def self.helper(*); end
    end
    klass.send(:include, ActiveAdmin::Devise::Controller)
    klass
  end

  let(:controller) { controller_class.new }

  it "should set the root path to the default namespace" do
    controller.root_path.should == "/admin"
  end

  it "should set the root path to '/' when no default namespace" do
    ActiveAdmin.application.stub!(:default_namespace => false)
    controller.root_path.should == "/"
  end

end
