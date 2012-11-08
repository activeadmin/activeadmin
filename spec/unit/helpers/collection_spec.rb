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
      collection_size(Post).should == 3
    end

    it "should return the collection size for an ActiveRecord::Relation" do
      collection_size(Post.where(:title => "A post")).should == 2
    end

    it "should return the collection size for a collection with group by" do
      collection_size(Post.group(:title)).should == 2
    end

    it "should return the collection size for a collection with group by, select and custom order" do
      collection_size(Post.select("title, count(*) as nb_posts").group(:title).order("nb_posts")).should == 2
    end

    it "should take the defined collection by default" do
      def collection; Post; end

      collection_size.should == 3

      def collection; Post.where(:title => "An other post"); end

      collection_size.should == 1
    end
  end

  describe "#collection_is_empty?" do
    it "should return true when the collection is empty" do
      collection_is_empty?(Post.where(:title => "Non existing post")).should be_true
    end

    it "should return false when the collection is not empty" do
      collection_is_empty?(Post.where(:title => "A post")).should be_false
    end

    it "should take the defined collection by default" do
      def collection; Post; end

      collection_is_empty?.should be_false

      def collection; Post.where(:title => "Non existing post"); end

      collection_is_empty?.should be_true
    end
  end
end
