require 'rails_helper'

describe ActiveAdmin::Formatter do
  let(:formatter) { double }
  let(:formatter_instance) { double }
  let(:object) { double }
  let(:formatted_object) { double }
  let(:view_context) { double }

  describe ".register" do
    it "registers a Formatter" do
      subject.register formatter
      expect(subject.formatters).to include(formatter)
    end
  end

  describe ".unregister" do
    it "unregisters a Formatter" do
      subject.formatters = [formatter]
      subject.unregister formatter
      expect(subject.formatters).to be_empty
    end
  end

  describe ".for" do
    it "should raise a NoFormatterRegistered" do
      expect(subject).to receive(:formatters).and_return([])
      expect {
        subject.for(object, view_context)
      }.to raise_error ActiveAdmin::NoFormatterRegistered
    end

    it "should raise a NoFormatterFound" do
      expect(formatter).to receive(:new).with(object, view_context).and_return(formatter_instance)
      expect(formatter_instance).to receive(:detect).and_return(false)
      expect(subject).to receive(:formatters).twice.and_return([formatter])
      expect {
        subject.for(object, view_context)
      }.to raise_error ActiveAdmin::NoFormatterFound
    end

    it "should find the formatter for the subject" do
      expect(formatter).to receive(:new).with(object, view_context).and_return(formatter_instance)
      expect(formatter_instance).to receive(:detect).and_return(true)
      expect(subject).to receive(:formatters).twice.and_return([formatter])
      expect(subject.for(object, view_context)).to eq formatter_instance
    end
  end

  describe ".format" do
    it "should find a formatter and process him" do
      expect(subject).to receive(:for).with(object, view_context).and_return(formatter_instance)
      expect(formatter_instance).to receive(:process).and_return(formatted_object)
      expect(subject.format(object, view_context)).to eq formatted_object
    end
  end

  describe "formatters" do
    describe "Base" do
      {
        String => ["hello", "hello"],
        Fixnum => [23, "23"],
        Float => [5.67, "5.67"],
        Bignum => [10**30, "1000000000000000000000000000000"]
      }.each do |klass, (object, expection)|
        it "should call `to_s` on #{klass.name}s" do
          expect(object).to be_a klass
          formatter = ActiveAdmin::Formatter::Base.new(object, view_context)
          expect(formatter.process).to eq expection
        end
      end
    end

    describe "DateTime" do
      let(:object) { Time.utc(1985, 2, 28, 20, 15, 1) }
      let(:formatter_instance) { ActiveAdmin::Formatter::DateTime.new(object, view_context) }

      it "should return a localized Date or Time with long format" do
        expect(view_context).to receive(:localize).with(object, { format: :long }) { "Just Now!" }
        expect(formatter_instance.process).to eq "Just Now!"
      end
    end

    describe "Arbre" do
      let(:object) { Arbre::Element.new }
      let(:formatter_instance) { ActiveAdmin::Formatter::Arbre.new(object, view_context) }

      it "should return rendered html" do
        expect(object).to receive(:to_s).and_return("<span>foo</span>")
        expect(formatter_instance.process).to eq "<span>foo</span>"
      end
    end
  end
end
