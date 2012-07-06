# encoding: utf-8
require 'spec_helper_without_rails'
require 'support/fake_app'

# @see https://github.com/svenfuchs/rails-i18n/blob/master/spec/integration/translation_spec.rb
describe "Translation" do

  let(:app) do
    ActiveAdmin::Spec::FakeApp
  end

  context "when default locale is not English" do
    let(:translation) do
      app.run lambda { I18n.t("active_admin.view") } do |config|
        config.i18n.default_locale = :de
      end
    end

    it "is available" do
      translation.should == "Anzeigen"
    end
  end
end