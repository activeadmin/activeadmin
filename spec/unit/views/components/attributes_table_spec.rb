require 'spec_helper'

describe ActiveAdmin::Views::AttributesTable do

  describe "creating with the dsl" do
    let(:helpers) { action_view }

    let(:post) do
      post = Post.new :title => "Hello World", :body => nil
      post.stub(:id){ 1 }
      post.stub(:new_record?){ false }
      post
    end

    let(:assigns){ { :post => post } }

    # Loop through a few different ways to make the same table
    # and ensure that they produce the same results
    {
      "when attributes are passed in to the builder methods" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post, :id, :title, :body
        }
      },
      "when attributes are built using the block" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post do
            rows :id, :title, :body
          end
        }
      },
      "when each attribute is passed in by itself" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post do
            row :id
            row :title
            row :body
          end
        }
      },
      "when you create each row with a custom block" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post do
            row("Id")   { post.id }
            row("Title"){ post.title }
            row("Body") { post.body }
          end
        }
      },
      "when you create each row with a custom block that returns nil" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post do
            row("Id")   { text_node post.id; nil }
            row("Title"){ text_node post.title; nil }
            row("Body") { text_node post.body; nil }
          end
        }
      },
    }.each do |context_title, table_decleration|
      context context_title do
        let(:table) { instance_eval &table_decleration }

        it "should render a div wrapper with the class '.attributes_table'" do
          table.tag_name.should == 'div'
          table.attr(:class).should include('attributes_table')
        end

        it "should add id and type class" do
          table.class_names.should include("post")
          table.id.should == "attributes_table_post_1"
        end

        it "should render 3 rows" do
          table.find_by_tag("tr").size.should == 3
        end

        describe "rendering the rows" do
          [
            ["Id" , "1"],
            ["Title" , "Hello World"],
            ["Body" , "<span class=\"empty\">Empty</span>"]
          ].each_with_index do |set, i|
            describe "for #{set[0]}" do
              let(:title){ set[0] }
              let(:content){ set[1] }
              let(:current_row){ table.find_by_tag("tr")[i] }

              it "should have the title '#{set[0]}'" do
                current_row.find_by_tag("th").first.content.should == title
              end
              it "should have the content '#{set[1]}'" do
                current_row.find_by_tag("td").first.content.chomp.strip.should == content
              end
            end
          end
        end # describe rendering rows

      end
    end # describe dsl styles

    it "should add a class for each row based on the col name" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row :title
          row :created_at
        end
      }
      table.find_by_tag("tr").first.to_s.
        split("\n").first.lstrip.
          should == '<tr class="row row-title">'

      table.find_by_tag("tr").last.to_s.
        split("\n").first.lstrip.
          should == '<tr class="row row-created_at">'
    end

    it "should allow html options for the row itself" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row("Wee", :class => "custom_row", :style => "custom_style") { }
        end
      }
      table.find_by_tag("tr").first.to_s.
        split("\n").first.lstrip.
          should == '<tr class="row custom_row" style="custom_style">'
    end

    it "should allow html content inside the attributes table" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row("ID"){ span(post.id, :class => 'id') }
        end
      }
      table.find_by_tag("td").first.content.chomp.strip.should == "<span class=\"id\">1</span>"
    end

    it "should check if an association exists when an attribute has id in it" do
      post.author = User.new :username => 'john_doe', :first_name => 'John', :last_name => 'Doe'
      table = render_arbre_component(assigns) {
        attributes_table_for post, :author_id
      }
      table.find_by_tag('td').first.content.should == 'John Doe'
    end

    context "with a collection" do
      let(:posts) do
        [Post.new(:title => "Hello World", :id => 1), Post.new(:title => "Multi Column", :id => 2)].each_with_index do |post, index|
          post.stub(:id => index + 1, :new_record? => false)
        end
      end

      let(:assigns) { { :posts => posts } }

      let(:table) do
        render_arbre_component(assigns) do
          attributes_table_for posts, :id, :title
        end
      end

      it "does not set id on the table" do
        table.attr(:id).should be_nil
      end

      context "colgroup" do
        let(:cols) { table.find_by_tag "col" }

        it "contains a col for each record (plus headers)" do
          cols.size.should == (2 + 1)
        end

        it "assigns an id to each col" do
          cols[1..-1].each_with_index do |col, index|
            col.id.should == "attributes_table_post_#{index + 1}"
          end
        end

        it "assigns a class to each col" do
          cols[1..-1].each_with_index do |col, index|
            col.class_names.should include("post")
          end
        end

        it "assigns alternation classes to each col" do
          cols[1..-1].each_with_index do |col, index|
            col.class_names.should include(["even", "odd"][index % 2])
          end
        end
      end

      context "when rendering the rows" do
        it "should contain 3 columns" do
          table.find_by_tag("tr").first.children.size.should == 3
        end

        [
          ["Id" , "1", "2"],
          ["Title", "Hello World", "Multi Column"],
        ].each_with_index do |set, i|
          describe "for #{set[0]}" do
            let(:title){ set[0] }
            let(:content){ set[1] }
            let(:current_row){ table.find_by_tag("tr")[i] }

            it "should have the title '#{set[0]}'" do
              current_row.find_by_tag("th").first.content.should == title
            end

            set[1..-1].each_with_index do |content, index|
              it "column #{index} should have the content '#{content}'" do
                current_row.find_by_tag("td")[index].content.chomp.strip.should == content
              end
            end
          end
        end
      end # describe rendering rows
    end # with a collection
  end

end
