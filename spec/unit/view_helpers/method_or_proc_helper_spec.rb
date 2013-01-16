require 'spec_helper'

describe MethodOrProcHelper do
  let(:receiver) { mock }

  let(:context) do
    obj = mock(:receiver_in_context => receiver)
    obj.extend MethodOrProcHelper
    obj
  end

  describe "#call_method_or_exec_proc" do

    it "should call the method in the context when a symbol" do
      context.call_method_or_exec_proc(:receiver_in_context).
        should == receiver
    end

    it "should call the method in the context when a string" do
      context.call_method_or_exec_proc("receiver_in_context").
        should == receiver
    end

    it "should exec a proc in the context" do
      test_proc = Proc.new{ raise "Success" if receiver_in_context }

      expect {
        context.call_method_or_exec_proc(test_proc)
      }.to raise_error("Success")
    end

  end

  describe "#call_method_or_proc_on" do

    context "when a symbol" do

      it 'should call the method on the receiver' do
        receiver.should_receive(:hello).and_return("hello")

        context.call_method_or_proc_on(receiver, "hello").
          should == "hello"
      end

      it "should receive additional arguments" do
        receiver.should_receive(:hello).with("world").and_return("hello world")

        context.call_method_or_proc_on(receiver, :hello, "world").
          should == "hello world"
      end

    end

    context "when a proc" do

      it "should exec the block in the context and pass in the receiver" do
        test_proc = Proc.new do |arg|
          raise "Success!" if arg == receiver_in_context
        end

        expect {
          context.call_method_or_proc_on(receiver,test_proc)
        }.to raise_error("Success!")
      end

      it "should receive additional arguments" do
        test_proc = Proc.new do |arg1, arg2|
          raise "Success!" if arg1 == receiver_in_context && arg2 == "Hello"
        end

        expect {
          context.call_method_or_proc_on(receiver, test_proc, "Hello")
        }.to raise_error("Success!")
      end

    end

    context "when a proc and :exec => false" do

      it "should call the proc and pass in the receiver" do
        obj_not_in_context = mock

        test_proc = Proc.new do |arg|
          raise "Success!" if arg == receiver && obj_not_in_context
        end

        expect {
          context.call_method_or_proc_on(receiver,test_proc, :exec => false)
        }.to raise_error("Success!")
      end

    end


  end

end
