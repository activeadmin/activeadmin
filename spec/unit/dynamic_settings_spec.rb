require 'rails_helper'

RSpec.describe ActiveAdmin::DynamicSettingsNode do
  subject { ActiveAdmin::DynamicSettingsNode.build }

  context "StringSymbolOrProcSetting" do
    before { subject.register :foo, 'bar', :string_symbol_or_proc }

    it "should pass through a string" do
      subject.foo = "string"
      expect(subject.foo(self)).to eq "string"
    end

    it "should instance_exec if context given" do
      ctx = Hash[i: 42]
      subject.foo = proc { self[:i] += 1 }
      expect(subject.foo(ctx)).to eq 43
      expect(subject.foo(ctx)).to eq 44
    end

    it "should send message if symbol given" do
      ctx = double
      expect(ctx).to receive(:quux).and_return 'qqq'
      subject.foo = :quux
      expect(subject.foo(ctx)).to eq 'qqq'
    end
  end
end
