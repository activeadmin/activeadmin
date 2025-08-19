# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::IndexHelper, type: :helper do
  describe "#collection_size" do
    before do
      Post.create!(title: "A post")
      Post.create!(title: "A post")
      Post.create!(title: "Another post")
    end

    it "should take the defined collection by default" do
      expect(helper).to receive(:collection).and_return(Post.where(nil))
      expect(helper.collection_size).to eq 3

      expect(helper).to receive(:collection).and_return(Post.where(title: "Another post"))
      expect(helper.collection_size).to eq 1

      expect(helper).to receive(:collection).and_return(Post.where(title: "A post").to_a)
      expect(helper.collection_size).to eq 2
    end

    context "with argument" do
      it "should return the collection size for an ActiveRecord class" do
        expect(helper.collection_size(Post.where(nil))).to eq 3
      end

      it "should return the collection size for an ActiveRecord::Relation" do
        expect(helper.collection_size(Post.where(title: "A post"))).to eq 2
      end

      it "should return the collection size for a collection with group by" do
        expect(helper.collection_size(Post.group(:title))).to eq 2
      end

      it "should return the collection size for a collection with group by, select and custom order" do
        expect(helper.collection_size(Post.select("title, count(*) as nb_posts").group(:title).order("nb_posts"))).to eq 2
      end

      it "should return the collection size for an Array" do
        expect(helper.collection_size(Post.where(title: "A post").to_a)).to eq 2
      end
    end
  end

  describe "#collection_empty?" do
    it "should take the defined collection by default" do
      expect(helper).to receive(:collection).twice.and_return(Post.all)

      expect(helper.collection_empty?).to eq true

      Post.create!(title: "Title")
      expect(helper.collection_empty?).to eq false
    end

    context "with argument" do
      before do
        Post.create!(title: "A post")
        Post.create!(title: "Another post")
      end

      it "should return true when the collection is empty" do
        expect(helper.collection_empty?(Post.where(title: "Non existing post"))).to eq true
      end

      it "should return false when the collection is not empty" do
        expect(helper.collection_empty?(Post.where(title: "A post"))).to eq false
      end
    end
  end
end
