require 'spec_helper'

describe ActiveAdmin::Component do

  let(:component_class){ Class.new(ActiveAdmin::Component) }
  let(:component){ component_class.new }

  it "should be a subclass of an html div" do
    ActiveAdmin::Component.ancestors.should include(ActiveAdmin::HTML::Div)
  end

  it "should render to a div, even as a subclass" do
    component.tag_name.should == 'div'
  end

end
