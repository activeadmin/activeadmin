require 'spec_helper'

describe "display names" do

  include ActiveAdmin::ViewHelpers

  [:display_name, :full_name, :name, :username, :login, :title, :email, :to_s].each do |m|
    it "should return #{m} if defined" do
      r = Class.new do
        define_method m do
          m.to_s
        end
      end.new
      display_name(r).should == m.to_s
    end
  end

  it "should memeoize the result for the class" do
    c = Class.new do
      def name
        "My Name"
      end
    end
    display_name(c.new).should == "My Name"
    ActiveAdmin.application.should_not_receive(:display_name_methods)
    display_name(c.new).should == "My Name"
  end

end
