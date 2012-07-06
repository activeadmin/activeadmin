# encoding: utf-8
require 'spec_helper_without_rails'
require 'support/fake_app'

# @see https://github.com/svenfuchs/rails-i18n/blob/master/spec/integration/optional_locale_loading_spec.rb
describe "ActiveAdmin-i18n" do
  let(:app) do
    ActiveAdmin::Spec::FakeApp
  end

  context "when i18n.available_locales are specified in config" do
    let(:i18n_results) do
      de_translate = lambda { I18n.t "active_admin.view", :locale => :de }
      ru_translate = lambda { I18n.t "active_admin.view", :locale => :ru }

      app.run(de_translate, ru_translate)  do |config|
        config.i18n.available_locales = [:ru, :en]
      end
    end

    it "loads only specified locales" do
      de_translate, ru_translate = *i18n_results

      de_translate.should == 'translation missing: de.active_admin.view'
      ru_translate.should == 'Открыть'
    end
  end

  context "when single locale is assigned to i18n.available_locales" do
    let(:translations) do
      fr = lambda { I18n.t "active_admin.view" }
      it = lambda { I18n.t "active_admin.view", :locale => :it }

      app.run(fr, it)  do |config|
        config.i18n.default_locale = 'fr'
        config.i18n.available_locales = 'fr'
      end
    end

    it "loads only this locale" do
      fr_translation, it_translation = *translations

      fr_translation.should == 'Voir'
      it_translation.should == 'translation missing: it.active_admin.view'
    end
  end
end
