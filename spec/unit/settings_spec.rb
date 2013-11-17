require 'spec_helper'

describe ActiveAdmin::Settings do

  subject{ Class.new{ include ActiveAdmin::Settings } }

  it{ should respond_to :setting }
  it{ should respond_to :deprecated_setting }
  it{ should respond_to :default_settings }

  describe "class API" do
    it "should create settings" do
      subject.setting :foo, 'bar'
      subject.default_settings[:foo].should eq 'bar'
    end

    it "should create deprecated settings" do
      ActiveAdmin::Deprecation.should_receive(:deprecate).twice
      subject.deprecated_setting :baz, 32
      subject.default_settings[:baz].should eq 32
    end
  end

  describe "instance API" do

    before do
      subject.setting :foo, 'bar'
      subject.deprecated_setting :baz, 32
    end
    let(:instance) { subject.new }

    it "should have access to a default value" do
      instance.foo.should eq 'bar'
      instance.foo = 'qqq'
      instance.foo.should eq 'qqq'
    end

    it "should have access to a deprecated value" do
      ActiveAdmin::Deprecation.should_receive(:warn).exactly(3).times
      instance.baz.should eq 32
      instance.baz = [45]
      instance.baz.should eq [45]
    end
  end

end


describe ActiveAdmin::Settings::Inheritance do

  subject do
    Class.new do
      include ActiveAdmin::Settings
      include ActiveAdmin::Settings::Inheritance
    end
  end

  it{ should respond_to :settings_inherited_by }
  it{ should respond_to :inheritable_setting }
  it{ should respond_to :deprecated_inheritable_setting }

  let(:heir) { Class.new }

  before do
    subject.settings_inherited_by heir
  end

  describe "class API" do
    it "should add setting to an heir" do
      subject.inheritable_setting :one, 2
      heir.default_settings[:one].should eq 2
    end

    it "should add deprecated setting to an heir" do
      ActiveAdmin::Deprecation.should_receive(:deprecate).exactly(4).times
      subject.deprecated_inheritable_setting :three, 4
      heir.default_settings[:three].should eq 4
    end
  end

  describe "instance API" do
    before{ subject.inheritable_setting :left, :right }
    it "should work" do
      heir.new.left.should eq :right
    end
  end

end
