# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::PagyAdapter do
  let(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }
  let(:resource) { ActiveAdmin::Resource.new(namespace, Post) }

  before do
    # Avoid requiring the actual 'pagy' gem in unit tests
    allow_any_instance_of(described_class).to receive(:ensure_pagy!).and_return(true)
  end

  describe "#paginate" do
    before do
      Post.delete_all
      13.times { |i| Post.create!(title: "Post #{i}") }
    end

    it "wraps the page with a Kaminari-like API" do
      adapter = described_class.new(resource, {})
      page = 2
      per = 5

      result = adapter.paginate(Post.order(:id), page: page, per_page: per)

      expect(result).to respond_to(:current_page, :total_pages, :limit_value, :total_count, :offset)
      expect(result.current_page).to eq 2
      expect(result.limit_value).to eq 5
      expect(result.total_count).to eq 13
      expect(result.total_pages).to eq 3
      expect(result.offset).to eq 5
      expect(result.length).to eq 5
    end

    it "uses resource.per_page when per_page is not provided" do
      resource.per_page = 4
      adapter = described_class.new(resource, {})

      result = adapter.paginate(Post.order(:id), page: 1)

      expect(result.limit_value).to eq 4
      expect(result.length).to eq 4
    end
  end

  describe "#paginated?" do
    it "returns true when the collection responds to pagination methods" do
      adapter = described_class.new(resource, {})
      fake = double(current_page: 1, total_pages: 1)
      expect(adapter.paginated?(fake)).to be true
    end

    it "returns false for a plain ActiveRecord::Relation" do
      adapter = described_class.new(resource, {})
      expect(adapter.paginated?(Post.all)).to be false
    end
  end
end
