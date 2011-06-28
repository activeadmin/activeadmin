require 'spec_helper'
require 'active_admin/helpers/settings'

describe ActiveAdmin::Settings do

  # A Class with settings module included
  let(:klass) do
    Class.new do
      include ActiveAdmin::Settings
      def initialize
        initialize_defaults!
      end
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

end
