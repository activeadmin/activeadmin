require 'spec_helper'
require 'active_admin/event'

describe ActiveAdmin::EventDispatcher do

  let(:test_event){ 'active_admin.test_event' }
  let(:dispatcher){ ActiveAdmin::EventDispatcher.new }

  it "should add a subscriber for an event" do
    expect(dispatcher.subscribers(test_event).size).to eq 0
    dispatcher.subscribe(test_event){ true }
    expect(dispatcher.subscribers(test_event).size).to eq 1
  end

  it "should add a subscriber for multiple events" do
    dispatcher.subscribe(test_event, test_event + "1"){ true }
    expect(dispatcher.subscribers(test_event).size).to eq 1
    expect(dispatcher.subscribers(test_event + "1").size).to eq 1
  end

  it "should call the dispatch block with no arguments" do
    dispatcher.subscribe(test_event){ raise StandardError, "From Event Handler" }
    expect {
      dispatcher.dispatch(test_event)
    }.to raise_error(StandardError, "From Event Handler")
  end

  it "should call the dispatch block with one argument" do
    arg = nil
    dispatcher.subscribe(test_event){|passed_in| arg = passed_in }
    dispatcher.dispatch(test_event, "My Arg")
    expect(arg).to eq "My Arg"
  end

  it "should clear all subscribers" do
    dispatcher.subscribe(test_event){ false }
    dispatcher.subscribe(test_event + "_2"){ false }
    dispatcher.clear_all_subscribers!
    expect(dispatcher.subscribers(test_event).size).to eq 0
    expect(dispatcher.subscribers(test_event + "_2").size).to eq 0
  end

  it "should have a dispatcher available from ActiveAdmin::Event" do
    expect(ActiveAdmin::Event).to be_an_instance_of(ActiveAdmin::EventDispatcher)
  end

end
