require 'spec_helper'

def it_should_have_view(key, value)
  it "should have #{value} for view key '#{key}'" do
    subject.send(key).should  == value
  end
end

describe ActiveAdmin::ViewFactory do

  it_should_have_view :global_navigation,    ActiveAdmin::Views::TabbedNavigation
  it_should_have_view :action_items,         ActiveAdmin::Views::ActionItems
  it_should_have_view :header,               ActiveAdmin::Views::HeaderRenderer
  it_should_have_view :blank_slate,          ActiveAdmin::Views::BlankSlate
  it_should_have_view :popover,              ActiveAdmin::Views::Popover
  it_should_have_view :action_list_popover,  ActiveAdmin::Views::ActionListPopover
  it_should_have_view :batch_action_popover, ActiveAdmin::Views::BatchActionPopover

  it_should_have_view :dashboard_page,       ActiveAdmin::Views::Pages::Dashboard
  it_should_have_view :layout,               ActiveAdmin::Views::Pages::Layout

end
