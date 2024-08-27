# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Panel do
  let(:arbre_panel) do
    render_arbre_component do
      panel "My Title" do
        span("Hello World")
      end
    end
  end

  let(:panel_html) { Capybara.string(arbre_panel.to_s) }

  it "should have a title h3" do
    expect(panel_html).to have_css "h3", text: "My Title"
  end

  it "should have a contents div" do
    expect(panel_html).to have_css "div.panel-body"
  end

  it "should add children to the contents div" do
    expect(panel_html).to have_css "div.panel-body > span", text: "Hello World"
  end

  context "with html-safe title" do
    let(:arbre_panel) do
      title_with_html = %q[Title with <abbr>HTML</abbr>].html_safe
      render_arbre_component do
        panel(title_with_html)
      end
    end

    it "should allow a html_safe title" do
      expect(panel_html).to have_css "h3", text: "Title with HTML"
      expect(panel_html).to have_css "h3 > abbr", text: "HTML"
    end
  end

  describe "#children?" do
    let(:arbre_panel) do
      render_arbre_component do
        panel("A Panel")
      end
    end

    it "returns false if no children have been added to the panel" do
      expect(arbre_panel.children?).to eq false
    end
  end
end
