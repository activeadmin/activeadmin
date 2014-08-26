require 'rails_helper'

describe ActiveAdmin::Event do
  it "should be a dispatcher instance of ActiveAdmin::EventDispatcher" do
    expect(ActiveAdmin::Event).to be_an_instance_of(ActiveAdmin::EventDispatcher)
  end
end
