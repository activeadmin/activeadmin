require 'rails_helper'

describe ActiveAdmin::OrderClause do
  subject { described_class.new clause }

  let(:application) { ActiveAdmin::Application.new }
  let(:namespace)   { ActiveAdmin::Namespace.new application, :admin }
  let(:config)      { ActiveAdmin::Resource.new namespace, Post }

  describe 'id_asc (existing column)' do
    let(:clause) { 'id_asc' }

    it { is_expected.to be_valid }

    describe '#field' do
      subject { super().field }
      it { is_expected.to eq('id') }
    end

    describe '#order' do
      subject { super().order }
      it { is_expected.to eq('asc') }
    end

    specify '#to_sql prepends table name' do
      expect(subject.to_sql(config)).to eq '"posts"."id" asc'
    end
  end

  describe 'virtual_column_asc' do
    let(:clause) { 'virtual_column_asc' }

    it { is_expected.to be_valid }

    describe '#field' do
      subject { super().field }
      it { is_expected.to eq('virtual_column') }
    end

    describe '#order' do
      subject { super().order }
      it { is_expected.to eq('asc') }
    end

    specify '#to_sql' do
      expect(subject.to_sql(config)).to eq '"virtual_column" asc'
    end
  end

  describe "hstore_col->'field'_desc" do
    let(:clause) { "hstore_col->'field'_desc" }

    it { is_expected.to be_valid }

    describe '#field' do
      subject { super().field }
      it { is_expected.to eq("hstore_col->'field'") }
    end

    describe '#order' do
      subject { super().order }
      it { is_expected.to eq('desc') }
    end

    it 'converts to sql' do
      expect(subject.to_sql(config)).to eq %Q("hstore_col"->'field' desc)
    end
  end

  describe '_asc' do
    let(:clause) { '_asc' }

    it { is_expected.not_to be_valid }
  end

  describe 'nil' do
    let(:clause) { nil }

    it { is_expected.not_to be_valid }
  end
end
