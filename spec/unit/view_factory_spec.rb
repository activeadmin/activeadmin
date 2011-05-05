require 'spec_helper'

def it_should_have_view(key, value)
  it "should have #{value} for view key '#{key}'" do
    subject.send(key).should  == value
  end
end

describe ActiveAdmin::ViewFactory do

  it_should_have_view :global_navigation, ActiveAdmin::Views::TabsRenderer
  it_should_have_view :action_items,      ActiveAdmin::Views::ActionItems
  it_should_have_view :header,            ActiveAdmin::Views::HeaderRenderer
  it_should_have_view :dashboard_page,    ActiveAdmin::Views::Pages::Dashboard

end
