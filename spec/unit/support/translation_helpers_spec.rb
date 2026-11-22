# frozen_string_literal: true
require "rails_helper"

RSpec.describe TranslationHelpers do
  before do
    allow(I18n.config).to receive(:backend).and_return(I18n::Backend::Simple.new)
    allow(I18n).to receive(:available_locales).and_return(%i[en fr])
    I18n.backend.store_translations(:en, isolation: { value: "English" })
    I18n.backend.store_translations(:fr, isolation: { value: "French" })
  end

  it "restores the original locale's translation if the block changes locale" do
    I18n.with_locale(:en) do
      with_translation(%i[isolation value], "Temporary") do
        expect(I18n.t("isolation.value")).to eq("Temporary")
        I18n.locale = :fr
      end

      expect(I18n.t("isolation.value", locale: :en)).to eq("English")
      expect(I18n.t("isolation.value", locale: :fr)).to eq("French")
    end
  end

  it "restores the original locale's translation if the block raises" do
    I18n.with_locale(:en) do
      expect do
        with_translation(%i[isolation value], "Temporary") do
          I18n.locale = :fr
          raise "failure"
        end
      end.to raise_error("failure")

      expect(I18n.t("isolation.value", locale: :en)).to eq("English")
      expect(I18n.t("isolation.value", locale: :fr)).to eq("French")
    end
  end

  it "leaves a nil translation for a key that did not exist before the block" do
    I18n.with_locale(:en) do
      with_translation(%i[isolation temporary], "Temporary") do
        expect(I18n.t("isolation.temporary")).to eq("Temporary")
      end

      # The public backend API cannot delete an individual key. A nil value
      # behaves as a missing translation for lookup and fallback purposes.
      expect(I18n.t("isolation.temporary", default: "Fallback")).to eq("Fallback")
      expect(I18n.exists?("isolation.temporary")).to be(false)
    end
  end
end
