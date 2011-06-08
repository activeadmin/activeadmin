require 'spec_helper'

# Ensure we have both constants to play with
begin
  ActionDispatch::Reloader
rescue
  module ActionDispatch; module Reloader; end; end
end

begin
  ActionDispatch::Callbacks
rescue
  module ActionDispatch; module Callbacks; end; end
end


describe ActiveAdmin::Reloader do

  it "should use ActionDispatch::Reloader if rails 3.1" do
    reloader = ActiveAdmin::Reloader.new '3.1.0'
    reloader.reloader_class.should == ActionDispatch::Reloader
  end

  it "should use ActionDispatch::Callbacks if rails 3.0" do
    reloader = ActiveAdmin::Reloader.new '3.0.0'
    reloader.reloader_class.should == ActionDispatch::Callbacks
  end
end
