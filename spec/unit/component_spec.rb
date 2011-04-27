require 'spec_helper'

class MockComponentClass < ActiveAdmin::Component; end

describe ActiveAdmin::Component do

  let(:component_class){ MockComponentClass }
  let(:component){ component_class.new }

  it "should be a subclass of an html div" do
    ActiveAdmin::Component.ancestors.should include(Arbre::HTML::Div)
  end

  it "should render to a div, even as a subclass" do
    component.tag_name.should == 'div'
  end

end
