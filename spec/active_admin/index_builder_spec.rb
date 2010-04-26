require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::IndexBuilder do
  
  it "should raise an exception on display_method" do
    lambda {
      ActiveAdmin::IndexBuilder.new.display_method
    }.should raise_error
  end
  
end
