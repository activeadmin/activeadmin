require 'rails_helper'
require 'active_admin/view_helpers/display_helper'

RSpec.describe "#pretty_format" do
  let(:view_klass) do
    Class.new(ActionView::Base) do
      include ActiveAdmin::ViewHelpers
    end
  end

  let(:view) { mock_action_view(view_klass) }

  let(:formatted_obj) { view.pretty_format(obj) }

  shared_examples_for 'an object convertible to string' do
    it "should call `to_s` on the given object" do
      expect(formatted_obj).to eq obj.to_s
    end
  end

  context 'when given a string' do
    let(:obj) { 'hello' }

    it_behaves_like 'an object convertible to string'
  end

  context 'when given an integer' do
    let(:obj) { 23 }

    it_behaves_like 'an object convertible to string'
  end

  context 'when given a float' do
    let(:obj) { 5.67 }

    it_behaves_like 'an object convertible to string'
  end

  context 'when given an exponential' do
    let(:obj) { 10**30 }

    it_behaves_like 'an object convertible to string'
  end

  context 'when given a symbol' do
    let(:obj) { :foo }

    it_behaves_like 'an object convertible to string'
  end

  context 'when given an arbre element' do
    let(:obj) { Arbre::Element.new.br }

    it_behaves_like 'an object convertible to string'
  end

  shared_examples_for 'a time-ish object' do
    it "formats it with the default long format" do
      expect(formatted_obj).to eq "February 28, 1985 20:15"
    end

    it "formats it with a customized long format" do
      with_translation time: { formats: { long: "%B %d, %Y, %l:%M%P" } } do
        expect(formatted_obj).to eq "February 28, 1985,  8:15pm"
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
        expect(formatted_obj).to eq "28 Feb 20:15"
      end

      it "formats it with i18n custom format" do
        with_translation time: { formats: { short: "%-m %d %Y" } } do
          expect(formatted_obj).to eq "2 28 1985"
        end
      end
    end

    context "with non-English locale" do
      around do |example|
        I18n.with_locale(:es, &example)
      end

      it "formats it with the default long format" do
        expect(formatted_obj).to eq "28 de febrero de 1985 20:15"
      end

      it "formats it with a customized long format" do
        with_translation time: { formats: { long: "El %d de %B de %Y a las %H horas y %M minutos" } } do
          expect(formatted_obj).to eq "El 28 de febrero de 1985 a las 20 horas y 15 minutos"
        end
      end
    end
  end

  context 'when given a Time in utc' do
    let(:obj) { Time.utc(1985, "feb", 28, 20, 15, 1) }

    it_behaves_like 'a time-ish object'
  end

  context 'when given a DateTime' do
    let(:obj) { DateTime.new(1985, 2, 28, 20, 15, 1) }

    it_behaves_like 'a time-ish object'
  end

  context "given an ActiveRecord object" do
    let(:obj) { Post.new }

    it "should delegate to auto_link" do
      expect(view).to receive(:auto_link).with(obj).and_return("model name")
      expect(formatted_obj).to eq "model name"
    end
  end

  context "given an arbitrary object" do
    let(:obj)  { Class.new.new }

    it "should delegate to `display_name`" do
      expect(view).to receive(:display_name).with(obj) { "I'm not famous" }
      expect(formatted_obj).to eq "I'm not famous"
    end
  end
end
