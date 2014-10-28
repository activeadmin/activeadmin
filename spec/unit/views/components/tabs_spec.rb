require 'rails_helper'

describe ActiveAdmin::Views::Tabs do
  describe "creating with the dsl" do
    context "when creating tabs with a symbol" do
      let(:tabs) do
        render_arbre_component do
          tabs do
            tab :overview
          end
        end
      end

      it "should create a tab navigation bar based on the symbol" do
        expect(tabs.find_by_tag('li').first.content).to include "Overview"
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
