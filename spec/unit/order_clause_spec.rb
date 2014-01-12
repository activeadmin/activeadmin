require 'spec_helper'

describe ActiveAdmin::OrderClause do
  subject { described_class.new clause }

  let(:application) { ActiveAdmin::Application.new }
  let(:namespace)   { ActiveAdmin::Namespace.new application, :admin }
  let(:config)      { ActiveAdmin::Resource.new namespace, Post }

  describe 'id_asc (existing column)' do
    let(:clause) { 'id_asc' }

    it { should be_valid }
    its(:field) { should == 'id' }
    its(:order) { should == 'asc' }

    specify '#to_sql prepends table name' do
      expect(subject.to_sql(config)).to eq '"posts"."id" asc'
    end
  end

  describe 'virtual_column_asc' do
    let(:clause) { 'virtual_column_asc' }

    it { should be_valid }
    its(:field) { should == 'virtual_column' }
    its(:order) { should == 'asc' }

    specify '#to_sql' do
      expect(subject.to_sql(config)).to eq '"virtual_column" asc'
    end
  end

  describe "hstore_col->'field'_desc" do
    let(:clause) { "hstore_col->'field'_desc" }

    it { should be_valid }
    its(:field) { should == "hstore_col->'field'" }
    its(:order) { should == 'desc' }

    it 'converts to sql' do
      expect(subject.to_sql(config)).to eq %Q("hstore_col"->'field' desc)
    end
  end

  describe '_asc' do
    let(:clause) { '_asc' }

    it { should_not be_valid }
  end

  describe 'nil' do
    let(:clause) { nil }

    it { should_not be_valid }
  end
end
