require 'spec_helper'

describe "display_name" do

  include ActiveAdmin::ViewHelpers

  [:display_name, :full_name, :name, :username, :login, :title, :email, :to_s].each do |m|
    it "should return #{m} when defined" do
      r = Class.new do
        define_method m do
          m.to_s
        end
      end.new
      display_name(r).should eq m.to_s
    end
  end

  it "should memeoize the result for the class" do
    subject { Class.new.new }
    subject.should_receive(:name).twice.and_return "My Name"
    display_name(subject).should eq "My Name"
    ActiveAdmin.application.should_not_receive(:display_name_methods)
    display_name(subject).should eq "My Name"
  end

  it "should not call a method if it's an association" do
    subject { Class.new.new }
    subject.stub_chain(:class, :reflect_on_all_associations).and_return [ double(name: :login) ]
    subject.stub :login
    subject.should_not_receive :login
    subject.stub(:email).and_return 'foo@bar.baz'
    display_name(subject).should eq 'foo@bar.baz'
  end

  [nil, false].each do |type|
    it "should return nil when the passed object is #{type.inspect}" do
      display_name(type).should eq nil
    end
  end

end
