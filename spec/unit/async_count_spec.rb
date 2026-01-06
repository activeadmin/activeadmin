# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::AsyncCount do
  include ActiveAdmin::IndexHelper

  def seed_posts
    [1, 2].map do |i|
      Post.create!(title: "Test #{i}", author_id: i * 100)
    end
  end

  it "can be passed to the collection_size helper", if: Post.respond_to?(:async_count) do
    seed_posts

    expect(collection_size(described_class.new(Post.all))).to eq(Post.count)
    expect(collection_size(described_class.new(Post.group(:author_id)))).to eq(Post.distinct.pluck(:author_id).size)
  end

  describe "#initialize" do
    let(:collection) { Post.all }

    it "initiates an async_count query", if: Post.respond_to?(:async_count) do
      expect(collection).to receive(:async_count)
      described_class.new(collection)
    end

    it "raises an error when ActiveRecord async_count is unavailable", unless: Post.respond_to?(:async_count) do
      expect do
        described_class.new(collection)
      end.to raise_error(ActiveAdmin::AsyncCount::NotSupportedError, %r{does not support :async_count})
    end
  end

  describe "#count", if: Post.respond_to?(:async_count) do
    before { seed_posts }

    it "returns the result of a count query" do
      async_count = described_class.new(Post.all)
      expect(async_count.count).to eq(Post.count)
    end

    it "returns the Hash of counts for a grouped query" do
      async_count = described_class.new(Post.group(:author_id))
      expect(async_count.count).to eq(100 => 1, 200 => 1)
    end
  end

  describe "delegation", if: Post.respond_to?(:async_count) do
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
