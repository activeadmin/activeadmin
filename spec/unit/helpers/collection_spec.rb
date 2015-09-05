require 'spec_helper'

describe ActiveAdmin::Helpers::Collection do

  include ActiveAdmin::Helpers::Collection

  before(:all) do
    Post.delete_all
    Post.create!(:title => "A post")
    Post.create!(:title => "A post")
    Post.create!(:title => "An other post")
  end

  after(:all) do
    Post.delete_all
  end

  describe "#collection_size" do
    it "should return the collection size for an ActiveRecord class" do
      expect(collection_size(Post)).to eq 3
    end

    it "should return the collection size for an ActiveRecord::Relation" do
      expect(collection_size(Post.where(:title => "A post"))).to eq 2
    end

    it "should return the collection size for a collection with group by" do
      expect(collection_size(Post.group(:title))).to eq 2
    end

    it "should return the collection size for a collection with group by, select and custom order" do
      expect(collection_size(Post.select("title, count(*) as nb_posts").group(:title).order("nb_posts"))).to eq 2
    end
  end

  describe "#collection_is_empty?" do
    it "should return true when the collection is empty" do
      expect(collection_is_empty?(Post.where(:title => "Non existing post"))).to be_true
    end

    it "should return false when the collection is not empty" do
      expect(collection_is_empty?(Post.where(:title => "A post"))).to be_false
    end
  end
end
