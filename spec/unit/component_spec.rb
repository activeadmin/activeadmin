# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Component do
  let(:component_class) { Class.new(described_class) }
  let(:component) { component_class.new }

  it "should be a subclass of an html div" do
    expect(ActiveAdmin::Component.ancestors).to include(Arbre::HTML::Div)
  end

  it "should render to a div, even as a subclass" do
    expect(component.tag_name).to eq "div"
  end

  it "should not have a CSS class name by default" do
    expect(component.class_list.empty?).to eq true
  end
end
