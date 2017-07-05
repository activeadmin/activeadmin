require 'rails_helper'

RSpec.describe ActiveAdmin::Views::Tabs do
  describe "creating with the dsl" do
    context "when creating tabs with a symbol" do
      before do
        expect(I18n).to receive(:t).at_least(:once).with(:tab_key).and_return "テスト"
      end

      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview
            tab I18n.t(:tab_key), { id: :something_unique }
          end
        end
      end

      let(:subject) { Capybara.string(tabs.to_s) }

      it "should create a tab navigation bar based on the symbol" do
        expect(subject).to have_content('Overview')
      end

      it "should have tab with id based on symbol" do
        expect(subject).to have_selector('div#overview')
      end

      it "should have link with fragment based on symbol" do
        expect(subject).to have_selector('a[href="#overview"]')
      end

      it "should handle translation" do
        expect(subject).to have_content('テスト')
      end

      it "should have tab with id based on options" do
        expect(subject).to have_selector('div#something_unique')
      end

      it "should have link with fragment based on options" do
        expect(subject).to have_selector('a[href="#something_unique"]')
      end

    end

    context "when creating a tab with a block" do
      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview do
              span 'tab 1'
            end
          end
        end
      end

      it "should create a tab navigation bar based on the symbol" do
        expect(tabs.find_by_tag('li').first.content).to include "Overview"
      end

      it "should create a tab with a span inside of it" do
        expect(tabs.find_by_tag('span').first.content).to eq('tab 1')
      end
    end
  end
end
