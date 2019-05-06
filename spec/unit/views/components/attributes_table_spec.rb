require 'rails_helper'

RSpec.describe ActiveAdmin::Views::AttributesTable do
  describe "creating with the dsl" do
    let(:helpers) { mock_action_view }

    let(:post) do
      post = Post.new title: "Hello World", body: nil
      allow(post).to receive(:id) { 1 }
      allow(post).to receive(:new_record?) { false }
      post
    end

    let(:assigns) { { post: post } }

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
            row("Id") { post.id }
            row("Title") { post.title }
            row("Body") { post.body }
          end
        }
      },
      "when you create each row with a custom block that returns nil" => proc {
        render_arbre_component(assigns) {
          attributes_table_for post do
            row("Id")   { text_node post.id; nil }
            row("Title") { text_node post.title; nil }
            row("Body") { text_node post.body; nil }
          end
        }
      },
    }.each do |context_title, table_decleration|
      context context_title do
        let(:table) { instance_eval &table_decleration }

        it "should render a div wrapper with the class '.attributes_table'" do
          expect(table.tag_name).to eq 'div'
          expect(table.attr(:class)).to include('attributes_table')
        end

        it "should add id and type class" do
          expect(table.class_names).to include("post")
          expect(table.id).to eq "attributes_table_post_1"
        end

        it "should render 3 rows" do
          expect(table.find_by_tag("tr").size).to eq 3
        end

        describe "rendering the rows" do
          [
            ["Id" , "1"],
            ["Title" , "Hello World"],
            ["Body" , "<span class=\"empty\">Empty</span>"]
          ].each_with_index do |(title, content), i|
            describe "for #{title}" do
              let(:current_row) { table.find_by_tag("tr")[i] }

              it "should have the title '#{title}'" do
                expect(current_row.find_by_tag("th").first.content).to eq title
              end

              it "should have the content '#{content}'" do
                expect(current_row.find_by_tag("td").first.content.chomp.strip).to eq content
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
      expect(table.find_by_tag("tr").first.to_s.
        split("\n").first.lstrip).
          to eq '<tr class="row row-title">'

      expect(table.find_by_tag("tr").last.to_s.
        split("\n").first.lstrip).
          to eq '<tr class="row row-created_at">'
    end

    it "should allow html options for the row itself" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row("Wee", class: "custom_row", style: "custom_style") {}
        end
      }
      expect(table.find_by_tag("tr").first.to_s.split("\n").first.lstrip).
        to eq '<tr class="row custom_row" style="custom_style">'
    end

    it "should allow html content inside the attributes table" do
      table = render_arbre_component(assigns) {
        attributes_table_for(post) do
          row("ID") { span(post.id, class: 'id') }
        end
      }
      expect(table.find_by_tag("td").first.content.chomp.strip).to eq "<span class=\"id\">1</span>"
    end

    context 'an attribute ending in _id' do
      before do
        post.foo_id = 23
        post.author = User.new username: 'john_doe', first_name: 'John', last_name: 'Doe'
      end
      it 'should call the association if one exists' do
        table = render_arbre_component assigns do
          attributes_table_for post, :author
        end
        expect(table.find_by_tag('th').first.content).to eq 'Author'
        expect(table.find_by_tag('td').first.content).to eq 'John Doe'
      end
      it 'should not attempt to call a nonexistant association' do
        table = render_arbre_component assigns do
          attributes_table_for post, :foo_id
        end
        expect(table.find_by_tag('th').first.content).to eq 'Foo'
        expect(table.find_by_tag('td').first.content).to eq '23'
      end
    end

    context "with a collection" do
      let(:posts) do
        [Post.new(title: "Hello World", id: 1), Post.new(title: "Multi Column", id: 2)].each_with_index do |post, index|
          allow(post).to receive(:id).and_return(index + 1)
          allow(post).to receive(:new_record?).and_return(false)
        end
      end

      let(:assigns) { { posts: posts } }

      let(:table) do
        render_arbre_component(assigns) do
          attributes_table_for posts, :id, :title
        end
      end

      it "does not set id on the table" do
        expect(table.attr(:id)).to eq nil
      end

      context "colgroup" do
        let(:cols) { table.find_by_tag "col" }

        it "contains a col for each record (plus headers)" do
          expect(cols.size).to eq(2 + 1)
        end

        it "assigns an id to each col" do
          cols[1..-1].each_with_index do |col, index|
            expect(col.id).to eq "attributes_table_post_#{index + 1}"
          end
        end

        it "assigns a class to each col" do
          cols[1..-1].each_with_index do |col, index|
            expect(col.class_names).to include("post")
          end
        end

        it "assigns alternation classes to each col" do
          cols[1..-1].each_with_index do |col, index|
            expect(col.class_names).to include(["even", "odd"][index % 2])
          end
        end
      end

      context "when rendering the rows" do
        it "should contain 3 columns" do
          expect(table.find_by_tag("tr").first.children.size).to eq 3
        end

        [
          ["Id" , "1", "2"],
          ["Title", "Hello World", "Multi Column"],
        ].each_with_index do |set, i|
          describe "for #{set[0]}" do
            let(:title) { set[0] }
            let(:content) { set[1] }
            let(:current_row) { table.find_by_tag("tr")[i] }

            it "should have the title '#{set[0]}'" do
              expect(current_row.find_by_tag("th").first.content).to eq title
            end

            context "with defined attribute name translation" do
              it "should have the translated attribute name in the title" do
                with_translation activerecord: { attributes: { post: { title: 'Translated Title', id: 'Translated Id' } } } do
                  expect(current_row.find_by_tag("th").first.content).to eq "Translated #{title}"
                end
              end
            end

            set[1..-1].each_with_index do |content, index|
              it "column #{index} should have the content '#{content}'" do
                expect(current_row.find_by_tag("td")[index].content.chomp.strip).to eq content
              end
            end
          end
        end
      end # describe rendering rows
    end # with a collection

    context "when using a single Hash" do
      let(:table) do
        render_arbre_component nil, helpers do
          attributes_table_for foo: 1, bar: 2 do
            row :foo
            row :bar
          end
        end
      end
      it "should render" do
        expect(table.find_by_tag("th")[0].content).to eq "Foo"
        expect(table.find_by_tag("th")[1].content).to eq "Bar"
        expect(table.find_by_tag("td")[0].content).to eq "1"
        expect(table.find_by_tag("td")[1].content).to eq "2"
      end
    end

    context "when using an Array of Hashes" do
      let(:table) do
        render_arbre_component nil, helpers do
          attributes_table_for [{ foo: 1 }, { foo: 2 }] do
            row :foo
          end
        end
      end
      it "should render" do
        expect(table.find_by_tag("th")[0].content).to eq "Foo"
        expect(table.find_by_tag("td")[0].content).to eq "1"
        expect(table.find_by_tag("td")[1].content).to eq "2"
      end
    end
  end
end
