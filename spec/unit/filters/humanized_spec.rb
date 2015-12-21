require 'rails_helper'

describe ActiveAdmin::Filters::Humanized do
  describe '#value' do
    it 'should equal query string parameter if not an Array' do
      param = ['category_id_eq', '1']
      subject = ActiveAdmin::Filters::Humanized.new(param)
      expect(subject.value).to eq('1')
    end

    it 'should equal query string parameters separated by commas if an Array' do
      param = ['category_id_eq', ['1', '2']]
      subject = ActiveAdmin::Filters::Humanized.new(param)
      expect(subject.value).to eq("1, 2")
    end

    it 'should remove nil values before joining equal query string parameters separated by commas if an Array' do
      param = ['category_id_eq', ['1', nil, '2']]
      subject = ActiveAdmin::Filters::Humanized.new(param)
      expect(subject.value).to eq("1, 2")
    end
  end

  describe '#body' do
    context 'when Ransack predicate' do
      it 'parses language from Ransack' do
        param = ['category_id_eq', '1']
        subject = ActiveAdmin::Filters::Humanized.new(param)
        expect(subject.body).to eq('Category ID equals')
      end

      it 'handles strings with embedded predicates' do
        param = ['requires_approval_eq', '1']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.value).to eq('1')
        expect(humanizer.body).to eq('Requires Approval equals')
      end
    end

    context 'when ActiveAdmin predicate' do
      it 'parses language from ActiveAdmin' do
        param = ['name_starts_with', 'test']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq('Name starts with')
      end
    end

    context 'when unknown predicate' do
      it 'uses raw predicate string' do
        param = ['name_predicate_does_not_exist', 'test']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq("Name Predicate Does Not Exist")
      end
    end
  end
end
