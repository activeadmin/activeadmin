# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Filters, ".predicate_label" do
  it "translates a ransack predicate" do
    expect(described_class.predicate_label(:cont)).to eq "contains"
  end

  it "translates a case-insensitive predicate as its case-sensitive counterpart" do
    expect(described_class.predicate_label(:i_cont)).to eq "contains"
    expect(described_class.predicate_label("i_start")).to eq "starts with"
    expect(described_class.predicate_label(:i_end)).to eq "ends with"
  end

  it "prefers an explicit translation of a case-insensitive predicate" do
    with_translation %i[ransack predicates i_cont], "contains (any case)" do
      expect(described_class.predicate_label(:i_cont)).to eq "contains (any case)"
    end
  end

  it "returns an untranslated predicate as is" do
    expect(described_class.predicate_label(:unknown)).to eq "unknown"
  end
end
