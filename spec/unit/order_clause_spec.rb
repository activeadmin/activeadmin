# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::OrderClause do
  subject { described_class.new(config, clause) }

  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
  let(:config) { ActiveAdmin::Resource.new namespace, Post }

  describe "id_asc (existing column)" do
    let(:clause) { "id_asc" }

    it { is_expected.to be_valid }

    describe "#field" do
      subject { super().field }
      it { is_expected.to eq("id") }
    end

    describe "#order" do
      subject { super().order }
      it { is_expected.to eq("asc") }
    end

    specify "#to_sql prepends table name" do
      expect(subject.to_sql).to eq '"posts"."id" asc'
    end

    # Prevents automatically wrapping this test in a transaction. Check that we use the proper method to get a connection from the pool to quote the clause.
    # We don't want to run the test using a leased connection https://github.com/rails/rails/blob/v7.2.3/activerecord/lib/active_record/test_fixtures.rb#L161
    uses_transaction "#to_sql prepends table name"
  end

  describe "posts.id_asc" do
    let(:clause) { "posts.id_asc" }

    describe "#table_column" do
      subject { super().table_column }
      it { is_expected.to eq("posts.id") }
    end
  end

  describe "virtual_column_asc" do
    let(:clause) { "virtual_column_asc" }

    it { is_expected.to be_valid }

    describe "#field" do
      subject { super().field }
      it { is_expected.to eq("virtual_column") }
    end

    describe "#order" do
      subject { super().order }
      it { is_expected.to eq("asc") }
    end

    specify "#to_sql" do
      expect(subject.to_sql).to eq '"virtual_column" asc'
    end
  end

  describe "hstore_col->'field'_desc" do
    let(:clause) { "hstore_col->'field'_desc" }

    it { is_expected.to be_valid }

    describe "#field" do
      subject { super().field }
      it { is_expected.to eq("hstore_col->'field'") }
    end

    describe "#order" do
      subject { super().order }
      it { is_expected.to eq("desc") }
    end

    it "converts to sql" do
      expect(subject.to_sql).to eq %Q("hstore_col"->'field' desc)
    end
  end

  describe "_asc" do
    let(:clause) { "_asc" }

    it { is_expected.not_to be_valid }
  end

  describe "nil" do
    let(:clause) { nil }

    it { is_expected.not_to be_valid }
  end
end
