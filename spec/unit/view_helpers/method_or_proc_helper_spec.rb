require 'rails_helper'

describe MethodOrProcHelper do
  let(:receiver) { double }

  let(:context) do
    obj = double receiver_in_context: receiver
    obj.extend MethodOrProcHelper
    obj
  end

  describe "#call_method_or_exec_proc" do

    it "should call the method in the context when a symbol" do
      expect(context.call_method_or_exec_proc(:receiver_in_context)).to eq receiver
    end

    it "should call the method in the context when a string" do
      expect(context.call_method_or_exec_proc("receiver_in_context")).to eq receiver
    end

    it "should exec a proc in the context" do
      test_proc = Proc.new{ raise "Success" if receiver_in_context }

      expect {
        context.call_method_or_exec_proc(test_proc)
      }.to raise_error("Success")
    end

  end

  describe "#call_method_or_proc_on" do

    [:hello, 'hello'].each do |key|
      context "when a #{key.class}" do
        it "should call the method on the receiver" do
          expect(receiver).to receive(key).and_return 'hello'

          expect(context.call_method_or_proc_on(receiver, key)).to eq 'hello'
        end

        it "should receive additional arguments" do
          expect(receiver).to receive(key).with(:world).and_return 'hello world'

          expect(context.call_method_or_proc_on(receiver, key, :world)).to eq 'hello world'
        end
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

    context "when a proc and exec: false" do

      it "should call the proc and pass in the receiver" do
        obj_not_in_context = double

        test_proc = Proc.new do |arg|
          raise "Success!" if arg == receiver && obj_not_in_context
        end

        expect {
          context.call_method_or_proc_on(receiver,test_proc, exec: false)
        }.to raise_error("Success!")
      end

    end


  end

  describe "#render_or_call_method_or_proc_on" do
    [ :symbol, Proc.new{} ].each do |key|
      context "when a #{key.class}" do
        it "should call #call_method_or_proc_on" do
          options = { foo: :bar }
          expect(context).to receive(:call_method_or_proc_on).with(receiver, key, options).and_return("data")
          expect(context.render_or_call_method_or_proc_on(receiver, key, options)).to eq "data"
        end
      end
    end

    context "when a string" do
      it "should return the string" do
        expect(context.render_or_call_method_or_proc_on(receiver, "string")).to eq "string"
      end
    end
  end

  describe "#render_in_context" do
    let(:args) { [1, 2, 3] }

    context "when a Proc" do
      let(:object) { Proc.new { } }

      it "should instance_exec the Proc" do
        expect(receiver).to receive(:instance_exec).with(args, &object).and_return("data")
        expect(context.render_in_context(receiver, object, args)).to eq "data"
      end
    end

    context "when a Symbol" do
      it "should send the symbol" do
        expect(receiver).to receive(:public_send).with(:symbol, args).and_return("data")
        expect(context.render_in_context(receiver, :symbol, args)).to eq "data"
      end
    end

    context "when a Object (not Proc or String)" do
      let(:object) { Object.new }

      it "should return the Object" do
        expect(context.render_in_context(receiver, object)).to eq object
      end
    end
  end

end
