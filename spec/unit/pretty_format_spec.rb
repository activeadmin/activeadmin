require 'spec_helper'

describe "#pretty_format" do
  include ActiveAdmin::ViewHelpers::DisplayHelper

  context "when a String is passed in" do
    it "should return the String passed in" do
      pretty_format("hello").should == "hello"
    end
  end

  context "when a Date or a Time is passed in" do
    it "should return a localized Date or Time with long format" do
      t = Time.now
      self.should_receive(:localize).with(t, {:format => :long}) { "Just Now!" }
      pretty_format(t).should == "Just Now!"
    end
  end

  context "when an ActiveRecord object is passed in" do
    it "should delegate to auto_link" do
      post = Post.new
      self.should_receive(:auto_link).with(post) { "model name" }
      pretty_format(post).should == "model name"
    end
  end

  context "when something else is passed in" do
    it "should delegate to display_name" do
      something = Class.new.new
      self.should_receive(:display_name).with(something) { "I'm not famous" }
      pretty_format(something).should == "I'm not famous"
    end
  end
end
