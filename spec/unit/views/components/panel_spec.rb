require 'spec_helper'

describe ActiveAdmin::Views::Panel do

  let(:the_panel) do
    render_arbre_component do
      panel "My Title" do
        span("Hello World")
      end
    end
  end

  it "should have a title h3" do
    expect(the_panel.find_by_tag("h3").first.content).to eq "My Title"
  end

  it "should have a contents div" do
    expect(the_panel.find_by_tag("div").first.class_list).to include("panel_contents")
  end

  it "should add children to the contents div" do
    expect(the_panel.find_by_tag("span").first.parent).to eq the_panel.find_by_tag("div").first
  end

  it "should set the icon" do
    the_panel = render_arbre_component do
      panel("Title", icon: :arrow_down)
    end
    expect(the_panel.find_by_tag("h3").first.content).to include("span class=\"icon")
  end

  it "should allow a html_safe title (without icon)" do
    title_with_html = %q[Title with <abbr>HTML</abbr>].html_safe
    the_panel = render_arbre_component do
      panel(title_with_html)
    end
    expect(the_panel.find_by_tag("h3").first.content).to eq(title_with_html)
  end

  describe "#children?" do

    it "returns false if no children have been added to the panel" do
      the_panel = render_arbre_component do
        panel("A Panel")
      end
      expect(the_panel.children?).to eq false
    end

  end

end
