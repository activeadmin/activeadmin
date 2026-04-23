# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActiveAdmin::CollectionDecorator" do
  let(:number_decorator) do
    Class.new do
      def initialize(number)
        @number = number
      end

      def selectable?
        @number.even?
      end
    end
  end

  describe "#decorated_collection" do
    subject { collection.decorated_collection }
    let(:collection) { ActiveAdmin::CollectionDecorator.decorate((1..10).to_a, with: number_decorator) }

    it "returns an array of decorated objects" do
      expect(subject).to all(be_a(number_decorator))
    end
  end

  describe "array methods" do
    subject { ActiveAdmin::CollectionDecorator.decorate((1..10).to_a, with: number_decorator) }

    it "delegates them to the decorated collection" do
      expect(subject.count(&:selectable?)).to eq(5)
    end
  end
end
