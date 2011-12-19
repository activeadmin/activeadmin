require 'spec_helper'
require 'active_admin/event'

describe ActiveAdmin::EventDispatcher do

  let(:test_event){ 'active_admin.test_event' }
  let(:dispatcher){ ActiveAdmin::EventDispatcher.new }

  it "should add a subscriber for an event" do
    dispatcher.subscribers(test_event).size.should == 0
    dispatcher.subscribe(test_event){ true }
    dispatcher.subscribers(test_event).size.should == 1
  end

  it "should add a subscriber for multiple events" do
    dispatcher.subscribe(test_event, test_event + "1"){ true }
    dispatcher.subscribers(test_event).size.should == 1
    dispatcher.subscribers(test_event + "1").size.should == 1
  end

  it "should call the dispatch block with no arguments" do
    dispatcher.subscribe(test_event){ raise StandardError, "From Event Handler" }
    lambda {
      dispatcher.dispatch(test_event)
    }.should raise_error(StandardError, "From Event Handler")
  end

  it "should call the dispatch block with one argument" do
    arg = nil
    dispatcher.subscribe(test_event){|passed_in| arg = passed_in }
    dispatcher.dispatch(test_event, "My Arg")
    arg.should == "My Arg"
  end

  it "should clear all subscribers" do
    dispatcher.subscribe(test_event){ false }
    dispatcher.subscribe(test_event + "_2"){ false }
    dispatcher.clear_all_subscribers!
    dispatcher.subscribers(test_event).size.should == 0
    dispatcher.subscribers(test_event + "_2").size.should == 0
  end

  it "should have a dispatcher available from ActiveAdmin::Event" do
    ActiveAdmin::Event.should be_an_instance_of(ActiveAdmin::EventDispatcher)
  end

end
