require 'rails_helper'
require 'active_admin/view_helpers/display_helper'

RSpec.describe "#pretty_format" do
  include ActiveAdmin::ViewHelpers::DisplayHelper

  def method_missing(*args, &block)
    mock_action_view.send *args, &block
  end

  ['hello', 23, 5.67, 10**30, :foo, Arbre::Element.new.br(:foo)].each do |obj|
    it "should call `to_s` on #{obj.class}s" do
      expect(pretty_format(obj)).to eq obj.to_s
    end
  end

  shared_examples_for 'a time-ish object' do |t|
    it "formats it with the default long format" do
      expect(pretty_format(t)).to eq "February 28, 1985 20:15"
    end

    it "formats it with a customized long format" do
      with_translation time: { formats: { long: "%B %d, %Y, %l:%M%P" } } do
        expect(pretty_format(t)).to eq "February 28, 1985,  8:15pm"
      end
    end

    context "with a custom localize format" do
      around do |example|
        previous_localize_format = ActiveAdmin.application.localize_format
        ActiveAdmin.application.localize_format = :short
        example.call
        ActiveAdmin.application.localize_format = previous_localize_format
      end

      it "formats it with the default custom format" do
        expect(pretty_format(t)).to eq "28 Feb 20:15"
      end

      it "formats it with i18n custom format" do
        with_translation time: { formats: { short: "%-m %d %Y" } } do
          expect(pretty_format(t)).to eq "2 28 1985"
        end
      end
    end

    context "with non-English locale" do
      around do |example|
        I18n.with_locale(:es) { example.call }
      end

      it "formats it with the default long format" do
        expect(pretty_format(t)).to eq "28 de febrero de 1985 20:15"
      end

      it "formats it with a customized long format" do
        with_translation time: { formats: { long: "El %d de %B de %Y a las %H horas y %M minutos" } } do
          expect(pretty_format(t)).to eq "El 28 de febrero de 1985 a las 20 horas y 15 minutos"
        end
      end
    end
  end

  it_behaves_like 'a time-ish object', Time.utc(1985, "feb", 28, 20, 15, 1)
  it_behaves_like 'a time-ish object', DateTime.new(1985, 2, 28, 20, 15, 1)

  context "given an ActiveRecord object" do
    it "should delegate to auto_link" do
      post = Post.new
      expect(self).to receive(:auto_link).with(post) { "model name" }
      expect(pretty_format(post)).to eq "model name"
    end
  end

  context "given an arbitrary object" do
    it "should delegate to `display_name`" do
      something = Class.new.new
      expect(self).to receive(:display_name).with(something) { "I'm not famous" }
      expect(pretty_format(something)).to eq "I'm not famous"
    end
  end
end
