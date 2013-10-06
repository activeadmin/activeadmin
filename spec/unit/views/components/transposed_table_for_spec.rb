require 'spec_helper'

describe TransposedTableFor do
  describe "creating with the dsl" do

    let(:collection) do
      [Post.new(:title => "First Post"), Post.new(:title => "Second Post"), Post.new(:title => "Third Post")]
    end

    let(:assigns){ { :collection => collection } }
    let(:helpers){ mock_action_view }

    let(:thead) { table.find_by_tag("thead").first }
    let(:tbody) { table.find_by_tag("tbody").first }

    context "the rendered table" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column :title
            column :created_at
            column :updated_at
          end
        end
      end

      it "includes the 'transposed' class" do
        table.class_list.should include("transposed")
      end

      it "alternates 'odd' and 'even' row classes" do
        tbody.find_by_tag("tr")[0].class_list.should include("odd")
        tbody.find_by_tag("tr")[1].class_list.should include("even")
      end
    end

    context "when creating a column with a symbol" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column :title
          end
        end
      end

      it "should create a table header based on the symbol" do
        table.find_by_tag("th").first.content.should == "Title"
      end

      it "should create a table column for each element in the collection" do
        table.find_by_tag("thead").first.find_by_tag("th").size.should == 4 # 1 for head, 3 for rows
      end

      it "should create a table row for each column defined" do
        table.find_by_tag("tr").size.should == 1
      end

      ["First Post", "Second Post", "Third Post"].each_with_index do |content, index|
        it "should create a cell with #{content}" do
          table.find_by_tag("th")[1 + index].content.should == content
        end
      end
    end

    context "when creating many columns with symbols" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column :title
            column :created_at
          end
        end
      end

      # Title      | First Post | Second Post | Third Post
      # --------------------------------------------------
      # Created At | 2013-01-01 | 2013-02-01  | 2013-03-01

      it "should create a table header based on the symbol" do
        table.find_by_tag("th").first.content.should == "Title"
        table.find_by_tag("th").last.content.should == "Created At"
      end

      it "should add a class to each table header based on the col title" do
        table.find_by_tag("th").first.class_list.should include("title")
        table.find_by_tag("th").last.class_list.should  include("created_at")
      end

      it "should create a table column for each element in the collection" do
        thead.find_by_tag("th").size.should == 4 # 1 for heading, 3 for columns
      end

      it "should create a thead cell for each column" do
        thead.find_by_tag("th").size.should == 3 + 1
      end

      it "should create a cell for each tbody column" do
        tbody.find_by_tag("td").size.should == 3
      end

      it "should add a class for each head cell based on the col name" do
        table.find_by_tag("th")[1..3].each do |title|
          title.class_list.should include("title")
        end
      end

      it "should add a class for each body cell based on the col name" do
        tbody.find_by_tag("td")[1..3].each do |title|
          title.class_list.should include("created_at")
        end
      end
    end

    context "when creating a column with block content" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column :title do |post|
              span(post.title)
            end
          end
        end
      end

      it "should add a class to each table header based on the col name" do
        table.find_by_tag("th").first.class_list.should include("title")
      end

      [ "<span>First Post</span>",
        "<span>Second Post</span>",
        "<span>Third Post</span>" ].each_with_index do |content, index|
        it "should create a cell with #{content}" do
          table.find_by_tag("th")[1 + index].content.strip.should == content
        end
      end
    end

    context "when creating a column with multiple block content" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column :title do |post|
              span(post.title)
              span(post.title)
            end
          end
        end
      end

      3.times do |index|
        it "should create a cell with multiple elements in row #{index}" do
          table.find_by_tag("th")[1 + index].find_by_tag("span").size.should == 2
        end
      end
    end

    context "when creating many columns with symbols, blocks and strings" do
      let(:table) do
        render_arbre_component assigns do
          transposed_table_for(collection) do
            column "My Custom Title", :title
            column :created_at, :class => "datetime"
          end
        end
      end

      it "should add a class to each table header  based on class option or the col name" do
        table.find_by_tag("th").first.class_list.should  include("my_custom_title")
        table.find_by_tag("th").last.class_list.should  include("datetime")
      end

      it "should add a class to each cell based  on class option or the col name" do
        table.find_by_tag("th").first.class_list.should include("my_custom_title")
        table.find_by_tag("th").last.class_list.should  include("datetime")
      end
    end
  end
end
