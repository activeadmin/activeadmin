RSpec.describe ActiveAdmin::SettingsNode do
  subject { ActiveAdmin::SettingsNode.build }
  let!(:child) { ActiveAdmin::SettingsNode.build(subject) }

  context 'parent setting includes foo' do
    before { subject.register :foo, true }

    it 'returns parent settings' do
      expect(child.foo).to eq true
    end

    it 'fails if setting undefined' do
      expect do
        child.bar
      end.to raise_error(NoMethodError)
    end

    context 'child overrides foo' do
      before { child.foo = false }

      it { expect(child.foo).to eq false }
    end
  end
end
