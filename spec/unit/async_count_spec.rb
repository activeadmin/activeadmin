# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::AsyncCount, if: Post.respond_to?(:async_count) do
  include ActiveAdmin::IndexHelper

  def seed_posts
    [1, 2].map do |i|
      Post.create!(title: "Test #{i}", author_id: i * 100)
    end
  end

  it "can be passed to the collection_size helper" do
    seed_posts

    expect(collection_size(described_class.new(Post.all))).to eq(Post.count)
    expect(collection_size(described_class.new(Post.group(:author_id)))).to eq(Post.distinct.pluck(:author_id).size)
  end

  describe "#initialize" do
    it "initiates an async_count query" do
      collection = Post.all
      expect(collection).to receive(:async_count)
      described_class.new(collection)
    end
  end

  describe "#count" do
    before { seed_posts }

    it "returns the result of a count query" do
      async_count = described_class.new(Post.all)
      expect(async_count.count).to eq(Post.count)
    end

    it "returns the Hash of counts for a grouped query" do
      async_count = described_class.new(Post.group(:author_id))
      expect(async_count.count).to eq(100 => 1, 200 => 1)
    end

    # See https://github.com/rails/rails/issues/50776
    it "works around a Rails 7.1.3 bug with wrapped promises" do
      promise = instance_double(ActiveRecord::Promise, value: Post.count)
      promise_wrapper = instance_double(ActiveRecord::Promise, value: promise)
      collection = class_double(Post, async_count: promise_wrapper)
      allow(collection).to receive(:except).and_return(collection)

      expect(described_class.new(collection).count).to eq(Post.count)
    end
  end

  describe "delegation" do
    let(:collection) { Post.all }

    %i[
      except
      group_values
      length
      limit_value
    ].each do |method|
      it "delegates #{method}" do
        allow(collection).to receive(method).and_call_original

        async_count = described_class.new(collection)
        async_count.public_send(method)

        expect(collection).to have_received(method).at_least(:once)
      end
    end
  end
end
