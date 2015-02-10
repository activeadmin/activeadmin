require 'rails_helper'

Dir.glob('config/locales/*.yml') do |locale_file|
  describe locale_file do
    it { is_expected.to be_parseable }
    it { is_expected.to have_one_top_level_namespace }
    it { is_expected.to be_named_like_top_level_namespace }
    it { is_expected.to_not have_legacy_interpolations }
    it { is_expected.to have_a_valid_locale }
    it { is_expected.to be_a_subset_of 'config/locales/en.yml' }
  end
end
