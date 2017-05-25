require 'rails_helper'

RSpec.describe ActiveAdmin::Filters::Humanized do
  describe '#value' do
    let(:category) { Category.create!(name: 'Jazz') }

    context 'parameter points to a related model' do
      it 'should equal the :name of category instance' do
        param = ['category_id_eq', category.id]
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.value).to eq('Jazz')
      end
    end

    context 'parameter looks like a related model but does not' do
      it 'should equal query string parameter' do
        param = ['color_id_eq', '1']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.value).to eq('1')
      end
    end

    context 'parameter is a field' do
      it 'should equal query string parameter' do
        param = ['requires_approval_eq', '1']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.value).to eq('1')
      end
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

      it 'returns correct model name even if multi-word model' do
        class MultiWordKlass; end
        param = ['multi_word_klass_id_eq', 1]
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to start_with('Multi Word Klass')
      end

      it 'parses language from Ransack if filter is a related model' do
        param = ['category_id_eq', category.id]
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq('Category equals')
      end

      it 'parses language from Ransack if filter parameter looks like related model but does not' do
        param = ['color_id_eq', '1']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq('Color ID equals')
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

    context 'when column name similar to predicate' do
      it 'parses correct predicate' do
        param = ['time_start_gteq', 'test']
        humanizer = ActiveAdmin::Filters::Humanized.new(param)
        expect(humanizer.body).to eq('Time Start greater than or equal to')
      end
    end
  end
end
