# frozen_string_literal: true
require "i18n/tasks"
require "i18n-spec"

Dir.glob("config/locales/*.yml") do |locale_file|
  RSpec.describe locale_file do
    it { is_expected.to be_parseable }
    it { is_expected.to have_one_top_level_namespace }
    it { is_expected.to be_named_like_top_level_namespace }
    it { is_expected.to_not have_legacy_interpolations }
    it { is_expected.to have_a_valid_locale }
    it { is_expected.to be_a_subset_of "config/locales/en.yml" }
  end
end

RSpec.describe "I18n" do
  let(:i18n) { I18n::Tasks::BaseTask.new }

  let(:unused_keys) { i18n.unused_keys }
  let(:unused_key_count) { unused_keys.leaves.count }
  let(:unused_key_failure_msg) do
    "#{unused_key_count} unused i18n keys, run `bin/i18n-tasks unused` to show them"
  end

  let(:inconsistent_interpolations) { i18n.inconsistent_interpolations }
  let(:inconsistent_interpolation_key_count) { inconsistent_interpolations.leaves.count }
  let(:inconsistent_interpolation_failure_msg) do
    "#{inconsistent_interpolation_key_count} inconsistent interpolations, run `bin/i18n-tasks check-consistent-interpolations` to show them"
  end

  it "does not have unused keys" do
    expect(unused_keys).to be_empty, unused_key_failure_msg
  end

  it "does not have inconsistent interpolations" do
    expect(inconsistent_interpolations).to be_empty, inconsistent_interpolation_failure_msg
  end
end
