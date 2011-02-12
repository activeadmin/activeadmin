require 'spec_helper'

def it_should_have_view(key, value)
  it "should have #{value} for view key '#{key}'" do
    subject.send(key).should  == value
  end
end

describe ActiveAdmin::ViewFactory do

  it_should_have_view :global_navigation, ActiveAdmin::TabsRenderer

end
