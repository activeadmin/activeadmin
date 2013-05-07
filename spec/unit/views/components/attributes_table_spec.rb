require 'spec_helper'

describe ActiveAdmin::Views::AttributesTable do

  describe "creating with the dsl" do
    let(:helpers) { action_view }

    let(:post) do
      post = Post.new :title => "Hello World", :body => nil
      post.stub!(:id){ 1 }
      post.stub!(:new_record?){ false }
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

    it "should allow html options for the row itself" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row("Wee", :class => "custom_row", :style => "custom_style") { }
        end
      }
      table.find_by_tag("tr").first.to_s.
        split("\n").first.lstrip.
          should == '<tr class="custom_row" style="custom_style">'
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

  end

end
