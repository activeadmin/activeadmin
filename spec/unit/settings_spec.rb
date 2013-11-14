require 'spec_helper'

describe ActiveAdmin::Settings do

  subject{ Class.new{ include ActiveAdmin::Settings } }

  it{ should respond_to :setting }
  it{ should respond_to :deprecated_setting }
  it{ should respond_to :default_settings }

  describe "class API" do
    it "should create settings" do
      subject.setting :foo, 'bar'
      expect(subject.default_settings[:foo]).to eq 'bar'
    end

    it "should create deprecated settings" do
      expect(ActiveAdmin::Deprecation).to receive(:deprecate).twice
      subject.deprecated_setting :baz, 32
      expect(subject.default_settings[:baz]).to eq 32
    end
  end

  describe "instance API" do

    before do
      subject.setting :foo, 'bar'
      subject.deprecated_setting :baz, 32
    end
    let(:instance) { subject.new }

    it "should have access to a default value" do
      expect(instance.foo).to eq 'bar'
      instance.foo = 'qqq'
      expect(instance.foo).to eq 'qqq'
    end

    it "should have access to a deprecated value" do
      expect(ActiveAdmin::Deprecation).to receive(:warn).exactly(3).times
      expect(instance.baz).to eq 32
      instance.baz = [45]
      expect(instance.baz).to eq [45]
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
      expect(heir.default_settings[:one]).to eq 2
    end

    it "should add deprecated setting to an heir" do
      expect(ActiveAdmin::Deprecation).to receive(:deprecate).exactly(4).times
      subject.deprecated_inheritable_setting :three, 4
      expect(heir.default_settings[:three]).to eq 4
    end
  end

  describe "instance API" do
    before{ subject.inheritable_setting :left, :right }
    it "should work" do
      expect(heir.new.left).to eq :right
    end
  end

end
