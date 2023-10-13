# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Tabs do
  describe "creating with the dsl" do
    context "when creating tabs with a symbol" do
      before do
        # string.parameterize calls I18n.transliterate which calls I18n.t with 'i18n.transliterate.rule'.
        # We need to stub it to avoid errors if transliteration cache is not warmed up before this tests.
        # rspec ./spec/unit/views/components/tabs_spec.rb:42 --seed 57923
        allow(I18n).to receive(:t).with("i18n.transliterate.rule".to_sym, anything).and_call_original
        expect(I18n).to receive(:t).at_least(:once).with(:tab_key).and_return "テスト"
      end

      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview
            tab I18n.t(:tab_key), id: :something_unique, html_options: { class: :some_css_class }
          end
        end
      end

      let(:subject) { Capybara.string(tabs.to_s) }

      it "should create a tab navigation bar based on the symbol" do
        expect(subject).to have_content("Overview")
      end

      it "should have tab with id based on symbol" do
        expect(subject).to have_selector("div#overview")
      end

      it "should have link with fragment based on symbol" do
        expect(subject).to have_selector('a[href="#overview"]')
      end

      it "should handle translation" do
        expect(subject).to have_content("テスト")
      end

      it "should have tab with id based on options" do
        expect(subject).to have_selector("div#something_unique")
      end

      it "should have link with fragment based on options" do
        expect(subject).to have_selector('a[href="#something_unique"]')
      end

      it "should have li with specific css class" do
        expect(subject).to have_selector("li.some_css_class")
      end
    end

    context "when creating a tab with a block" do
      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview do
              span "tab 1"
            end
          end
        end
      end

      it "should create a tab navigation bar based on the symbol" do
        expect(tabs.find_by_tag("li").first.content).to include("Overview")
      end

      it "should create a tab with a span inside of it" do
        expect(tabs.find_by_tag("span").first.content).to eq("tab 1")
      end
    end

    context "when creating a tab with non-transliteratable string" do
      let(:tabs) do
        render_arbre_component do
          tabs do
            tab "🤗" do
              "content"
            end
          end
        end
      end

      let(:subject) { Capybara.string(tabs.to_s) }

      it "should create a tab navigation bar based on the string" do
        expect(subject).to have_content("🤗")
      end

      it "should have tab with id based on URL-encoded string" do
        tab_content = subject.find(".tabs .tab-content div", text: "content")
        expect(tab_content["id"]).to eq(CGI.escape("🤗"))
      end

      it "should have link with fragment based on URL-encoded string" do
        expect(subject).to have_link("🤗", href: "##{CGI.escape('🤗')}")
      end
    end
  end
end
