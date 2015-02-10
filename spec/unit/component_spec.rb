require 'rails_helper'

class MockComponentClass < ActiveAdmin::Component; end

describe ActiveAdmin::Component do

  let(:component_class){ MockComponentClass }
  let(:component){ component_class.new }

  it "should be a subclass of an html div" do
    expect(ActiveAdmin::Component.ancestors).to include(Arbre::HTML::Div)
  end

  it "should render to a div, even as a subclass" do
    expect(component.tag_name).to eq 'div'
  end

end
