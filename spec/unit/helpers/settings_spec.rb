require 'spec_helper'
require 'active_admin/helpers/settings'

describe ActiveAdmin::Settings do

  # A Class with settings module included
  let(:klass) do
    Class.new do
      include ActiveAdmin::Settings
    end
  end

  it "should add a new setting with a default" do
    klass.setting :my_setting, "Hello World"
    klass.default_settings[:my_setting].should == "Hello World"
  end

  it "should initialize the defaults" do
    klass.setting :my_setting, "Hello World"
    klass.new.my_setting.should == "Hello World"
  end

  it "should support settings of nil" do
    klass.setting :my_setting, :some_val
    inst = klass.new
    inst.my_setting = nil
    inst.my_setting.should == nil
  end

end
