require 'spec_helper'

describe "display_name" do

  include ActiveAdmin::ViewHelpers

  ActiveAdmin::Application.new.display_name_methods.map(&:to_s).each do |m|
    it "should return #{m} when defined" do
      klass = Class.new do
        define_method(m) { m }
      end
      expect(display_name klass.new).to eq m
    end
  end

  it "should memeoize the result for the class" do
    subject = Class.new.new
    expect(subject).to receive(:name).twice.and_return "My Name"
    expect(display_name subject).to eq "My Name"
    expect(ActiveAdmin.application).to_not receive(:display_name_methods)
    expect(display_name subject).to eq "My Name"
  end

  it "should not call a method if it's an association" do
    subject = Class.new.new
    subject.stub_chain(:class, :reflect_on_all_associations).and_return [ double(name: :login) ]
    allow(subject).to receive :login
    expect(subject).to_not receive :login
    allow(subject).to receive(:email).and_return 'foo@bar.baz'
    expect(display_name subject).to eq 'foo@bar.baz'
  end

  [nil, false].each do |type|
    it "should return nil when the passed object is #{type.inspect}" do
      expect(display_name type).to eq nil
    end
  end

  it "should default to `to_s`" do
    subject = Class.new.new
    expect(display_name subject).to eq subject.to_s
  end

  context "when no display name method is defined" do
    context "on a Rails model" do
      it "should show the model name" do
        class ThisModel
          extend ActiveModel::Naming
        end
        subject = ThisModel.new
        expect(display_name subject).to eq "This model"
      end

      it "should show the model name, plus the ID if in use" do
        subject = Tagging.create!
        expect(display_name subject).to eq "Tagging #1"
      end

      it "should translate the model name" do
        with_translation activerecord: {models: {tagging: {one: "Different"}}} do
          subject = Tagging.create!
          expect(display_name subject).to eq "Different #1"
        end
      end
    end
  end

end
