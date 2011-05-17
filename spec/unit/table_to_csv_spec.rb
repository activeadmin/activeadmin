require 'spec_helper'

describe ActiveAdmin::TableToCSV do
  include Arbre::HTML

  let(:assigns){ {} }
  let(:helpers){ action_view }

  let(:post_1){ Post.new(:title => "Hello world")}
  let(:post_2){ Post.new(:title => "Hello world 2")}

  let(:csv){ ActiveAdmin::TableToCSV.new(table).to_s }


  describe "a basic table" do
	let :table do
	  table_for [post_1, post_2] do
		column :title
		column :body
	  end
	end


	it "should render the table headers" do
	  csv.split("\n").first.should == "Title,Body"
	end

	it "should render the first row" do
	  csv.split("\n")[1].should == %{Hello world,""}
	end
  end

  describe "a table with html" do
	let :table do
	  table_for [post_1, post_2] do
		column(:title){|p| a p.title, :href => "/woot" }
		column(:body){|p| para p.body }
	  end
	end

	it "content without html tags" do
	  csv.split("\n")[1].should == %{Hello world,""}
	end
  end

end
