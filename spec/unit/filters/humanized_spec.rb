require 'rails_helper'

describe ActiveAdmin::Filters::Humanized do
  let(:param) { ['category_id_eq', '1'] }

  subject { ActiveAdmin::Filters::Humanized.new(param) }

  describe '#value' do
    it 'should equal query string parameter' do
      expect(subject.value).to eq('1')
    end
  end

  describe '#body' do
    context 'when Ransack predicate' do
      it 'parses language from Ransack' do
        expect(subject.body).to eq('Category ID equals')
      end

      it 'handles strings with embedded predicates' do
        param = ['requires_approval_eq', '1']
        human = ActiveAdmin::Filters::Humanized.new(param)
        expect(human.value).to eq('1')
        expect(human.body).to eq('Requires Approval equals')
      end
    end

    context 'when ActiveAdmin predicate' do
      it 'parses language from ActiveAdmin' do
        param = ['name_starts_with', 'test']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq('Name starts with')
      end
    end
  end
end
