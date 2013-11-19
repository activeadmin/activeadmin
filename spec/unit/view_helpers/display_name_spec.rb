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
      expect(display_name(r)).to eq m.to_s
    end
  end

  it "should memeoize the result for the class" do
    subject { Class.new.new }
    expect(subject).to receive(:name).twice.and_return "My Name"
    expect(display_name(subject)).to eq "My Name"
    expect(ActiveAdmin.application).to_not receive(:display_name_methods)
    expect(display_name(subject)).to eq "My Name"
  end

  it "should not call a method if it's an association" do
    subject { Class.new.new }
    subject.stub_chain(:class, :reflect_on_all_associations).and_return [ double(name: :login) ]
    subject.stub :login
    expect(subject).to_not receive :login
    subject.stub(:email).and_return 'foo@bar.baz'
    expect(display_name(subject)).to eq 'foo@bar.baz'
  end

  [nil, false].each do |type|
    it "should return nil when the passed object is #{type.inspect}" do
      expect(display_name(type)).to eq nil
    end
  end

end
