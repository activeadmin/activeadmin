# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Tabs do
  let(:subject) { Capybara.string(tabs.to_s) }

  describe "creating with the dsl" do
    context "when creating tabs with a symbol" do
      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview
            tab "Sample", id: :something_unique, html_options: { class: :some_css_class }
          end
        end
      end

      it "should create a tab navigation bar based on the symbol" do
        expect(subject).to have_content("Overview")
      end

      it "should have tab with id based on symbol" do
        expect(subject).to have_selector("#tabs-overview-#{tabs.object_id}")
      end

      it "should have a target attribute with fragment based on symbol" do
        expect(subject).to have_selector("[data-tabs-target='#tabs-overview-#{tabs.object_id}']")
      end

      it "should have tab with id based on options" do
        expect(subject).to have_selector("#something_unique")
      end

      it "should have link with fragment based on options" do
        expect(subject).to have_selector('[data-tabs-target="#something_unique"]')
      end

      it "should have button with specific css class" do
        expect(subject).to have_selector("button.some_css_class")
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
        expect(subject).to have_button("Overview")
      end

      it "should create a tab with a span inside of it" do
        expect(subject).to have_content("tab 1")
      end
    end
  end
end
