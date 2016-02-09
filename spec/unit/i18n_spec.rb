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

if RUBY_VERSION >= '2.1' && !RUBY_PLATFORM.include?('java')

  require 'i18n/tasks'

  describe 'I18n' do
    let(:i18n) { I18n::Tasks::BaseTask.new }
    let(:missing_keys) { i18n.missing_keys }

    pending 'FIXME: Run these examples after filling all missing keys' do
      it 'does not have missing keys' do
        expect(missing_keys).to be_empty,
          "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"
      end

      it 'does not have unused keys' do
        expect(unused_keys).to be_empty,
          "#{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to show them"
      end
    end
  end

end
