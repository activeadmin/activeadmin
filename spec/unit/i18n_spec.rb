require 'rails_helper'
require 'i18n/tasks'

Dir.glob('config/locales/*.yml') do |locale_file|
  RSpec.describe locale_file do
    it { is_expected.to be_parseable }
    it { is_expected.to have_one_top_level_namespace }
    it { is_expected.to be_named_like_top_level_namespace }
    it { is_expected.to_not have_legacy_interpolations }
    it { is_expected.to have_a_valid_locale }
    it { is_expected.to be_a_subset_of 'config/locales/en.yml' }
  end
end

RSpec.describe 'I18n' do
  let(:i18n) { I18n::Tasks::BaseTask.new }
  let(:unused_keys) { i18n.unused_keys }

  let(:failure_msg) do
    <<-MSG.squish
      #{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to
      show them
    MSG
  end

  it 'does not have unused keys' do
    expect(unused_keys).to be_empty, failure_msg
  end
end
