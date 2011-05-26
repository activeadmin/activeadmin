require 'spec_helper'

describe_with_render Admin::PostsController do
  describe "get index with format csv" do

    before do
      Post.create :title => "Hello World"
      Post.create :title => "Goodbye World"
    end

    it "should return csv" do
      get :index, 'format' => 'csv'
      response.content_type.should == 'text/csv'
    end

    it "should return a header and a line for each item" do
      get :index, 'format' => 'csv'
      response.body.split("\n").size.should == 3
    end

    Post.columns.each do |column|
      it "should include a header for #{column.name}" do
        get :index, 'format' => 'csv'
        response.body.split("\n").first.should include(column.name.titleize)
      end
    end

    it "should set a much higher per page pagination" do
      100.times{ Post.create :title => "woot" }
      get :index, 'format' => 'csv'
      response.body.split("\n").size.should == 103
    end

  end
end
