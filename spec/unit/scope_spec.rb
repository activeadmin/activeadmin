require 'rails_helper'

RSpec.describe ActiveAdmin::Scope do

  describe "creating a scope" do
    subject{ scope }

    context "when just a scope method" do
      let(:scope) { ActiveAdmin::Scope.new :published }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq("Published")}
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq("published")}
      end

      describe '#scope_method' do
        subject { super().scope_method }
        it      { is_expected.to eq(:published) }
      end
    end

    context "when scope method is :all" do
      let(:scope) { ActiveAdmin::Scope.new :all }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq("All")}
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq("all")}
      end
      # :all does not return a chain but an array of active record
      # instances. We set the scope_method to nil then.

      describe '#scope_method' do
        subject { super().scope_method }
        it      { is_expected.to eq(nil) }
      end

      describe '#scope_block' do
        subject { super().scope_block }
        it      { is_expected.to eq(nil) }
      end
    end

    context 'when a name and scope method is :all' do
      let(:scope) { ActiveAdmin::Scope.new 'Tous', :all }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq 'Tous' }
      end

      describe '#scope_method' do
        subject { super().scope_method }
        it      { is_expected.to eq nil }
      end

      describe '#scope_block' do
        subject { super().scope_block }
        it      { is_expected.to eq nil }
      end
    end

    context "when a name and scope method" do
      let(:scope) { ActiveAdmin::Scope.new "With API Access", :with_api_access }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq("With API Access")}
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq("with_api_access")}
      end

      describe '#scope_method' do
        subject { super().scope_method }
        it      { is_expected.to eq(:with_api_access) }
      end
    end

    context "when a name and scope block" do
      let(:scope) { ActiveAdmin::Scope.new("My Scope"){|s| s } }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq("My Scope")}
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq("my_scope")}
      end

      describe '#scope_method' do
        subject { super().scope_method }
        it      { is_expected.to eq(nil) }
      end

      describe '#scope_block' do
        subject { super().scope_block }
        it      { is_expected.to be_a(Proc)}
      end
    end

    context "when a name has a space and lowercase" do
      let(:scope) { ActiveAdmin::Scope.new("my scope") }

      describe '#name' do
        subject { super().name }
        it      { is_expected.to eq("my scope")}
      end

      describe '#id' do
        subject { super().id }
        it      { is_expected.to eq("my_scope")}
      end
    end

    context "with a proc as the label" do
      it "should raise an exception if a second argument isn't provided" do
        expect{
          ActiveAdmin::Scope.new proc{ Date.today.strftime '%A' }
        }.to raise_error 'A string/symbol is required as the second argument if your label is a proc.'
      end

      it "should properly render the proc" do
        scope = ActiveAdmin::Scope.new proc{ Date.today.strftime '%A' }, :foobar
        expect(scope.name.call).to eq Date.today.strftime '%A'
      end
    end

    context "with scope method and localizer" do
      let(:localizer) do
        loc = double(:localizer)
        allow(loc).to receive(:t).with(:published, scope: 'scopes').and_return("All published")
        loc
      end
      let(:scope) { ActiveAdmin::Scope.new :published, :published, localizer: localizer }

      describe '#name' do
        subject { super().name }
        it { is_expected.to eq("All published")}
      end

      describe '#id' do
        subject { super().id }
        it { is_expected.to eq("published")}
      end

      describe '#scope_method' do
        subject { super().scope_method }
        it { is_expected.to eq(:published) }
      end
    end

  end # describe "creating a scope"

  describe "#display_if_block" do
    it "should return true by default" do
      scope = ActiveAdmin::Scope.new(:default)
      expect(scope.display_if_block.call).to eq true
    end

    it "should return the :if block if set" do
      scope = ActiveAdmin::Scope.new(:with_block, nil, if: proc{ false })
      expect(scope.display_if_block.call).to eq false
    end
  end

  describe "#default" do
    it "should accept a boolean" do
      scope = ActiveAdmin::Scope.new(:method, nil, default: true)
      expect(scope.default_block).to eq true
    end

    it "should default to a false #default_block" do
      scope = ActiveAdmin::Scope.new(:method, nil)
      expect(scope.default_block.call).to eq false
    end

    it "should store the :default proc" do
      scope = ActiveAdmin::Scope.new(:with_block, nil, default: proc{ true })
      expect(scope.default_block.call).to eq true
    end
  end

  describe "show_count" do
    it "should allow setting of show_count to prevent showing counts" do
      scope = ActiveAdmin::Scope.new(:default, nil, show_count: false)
      expect(scope.show_count).to eq false
    end

    it "should set show_count to true if not passed in" do
      scope = ActiveAdmin::Scope.new(:default)
      expect(scope.show_count).to eq true
    end
  end

end
