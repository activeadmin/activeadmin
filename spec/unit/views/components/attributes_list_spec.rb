# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::AttributesList do
  describe "test samples" do
    let(:helpers) { mock_action_view }

    let(:post) do
      post = Post.new title: "Hello World", body: nil
      allow(post).to receive(:id) { 1 }
      allow(post).to receive(:new_record?) { false }
      post
    end

    let(:assigns) { { post: post } }

    it "test" do
      result = render_arbre_component(assigns) do
        attributes_list_for post, :id, :title, :body, group_html: { class: "grid gap-3" }, term_html: { class: "font-bold" }, description_html: { class: "text-gray-700" }
      end
      puts result.to_s
    end

    it "test2" do
      result = render_arbre_component(assigns) do
        attributes_list_for post do
          item :id
          item :title
          item :body
        end
      end
      puts result.to_s
    end

    it "test3" do
      result = render_arbre_component(assigns) do
        attributes_list_for(
          post,
          class: "mylist",
          data: { a: 1, b: 2 },
          group_html: { class: "grid gap-3" },
          term_html: { class: "font-bold" },
          description_html: { class: "text-gray-700" }
        ) do
          item :id
          item(:title, group_html: { class: "flex flex-wrap" }) do
            "Title-#{post.title}"
          end
          div do
            dt do
              "test"
            end
            dd do
              "value"
            end
          end
          item :body
        end
      end
      puts result.to_s
    end

    it "test4" do
      result = render_arbre_component(assigns) do
        attributes_list_for(
          post,
          class: "mylist",
          data: { a: 1, b: 2 },
          group_html: { class: "grid gap-3" },
          term_html: { class: "font-bold", data: { c: 3 } },
          description_html: { class: "text-gray-700" }
        ) do
          items :id, :body
          item(:title, group_html: { class: "flex flex-wrap" }) do
            "Title-#{post.title}"
          end
          item(:title, term: -> { span "custom-text-#{post.id}" }, group_html: { class: "flex flex-wrap" }) do
            "Custom-#{post.title}"
          end
          item(:title, term: -> { text_node "custom-text-#{post.id}" })
        end
      end
      puts result.to_s
    end
  end

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
        render_arbre_component(assigns) do
          attributes_list_for post, :id, :title, :body
        end
      },
      "when attributes are built using the block" => proc {
        render_arbre_component(assigns) do
          attributes_list_for post do
            items :id, :title, :body
          end
        end
      },
      "when each attribute is passed in by itself" => proc {
        render_arbre_component(assigns) do
          attributes_list_for post do
            item :id
            item :title
            item :body
          end
        end
      },
      "when you create each row with a custom block" => proc {
        render_arbre_component(assigns) do
          attributes_list_for post do
            item("Id") { post.id }
            item("Title") { post.title }
            item("Body") { post.body }
          end
        end
      },
      "when you create each row with a custom block that returns nil" => proc {
        render_arbre_component(assigns) do
          attributes_list_for post do
            item("Id") { text_node post.id; nil }
            item("Title") { text_node post.title; nil }
            item("Body") { text_node post.body; nil }
          end
        end
      },
    }.each do |context_title, dl_decleration|
      context context_title do
        let(:list) { instance_eval &dl_decleration }

        it "should render a dl with the class '.attributes_list'" do
          expect(list.tag_name).to eq "dl"
          expect(list.class_list).to include("attributes_list")
        end

        it "should render 3 groups" do
          expect(list.find_by_tag("div").size).to eq 3
          expect(list.find_by_tag("dt").size).to eq 3
          expect(list.find_by_tag("dd").size).to eq 3
        end

        describe "rendering the groups" do
          [
            ["Id", "1"],
            ["Title", "Hello World"],
            ["Body", "<span class=\"empty\">Empty</span>"]
          ].each_with_index do |(title, content), i|
            describe "for #{title}" do
              let(:current_item) { list.find_by_tag("div")[i] }

              it "should have the title '#{title}'" do
                expect(current_item.find_by_tag("dt").first.content).to eq title
              end

              it "should have the content '#{content}'" do
                expect(current_item.find_by_tag("dd").first.content.chomp.strip).to eq content
              end
            end
          end
        end # describe rendering rows
      end
    end # describe dsl styles

    it "should allow html content inside the attributes list" do
      table = render_arbre_component(assigns) do
        attributes_list_for(post) do
          item("ID") { span(post.id, class: "id") }
        end
      end
      expect(table.find_by_tag("dd").first.content.chomp.strip).to eq "<span class=\"id\">1</span>"
    end

    context "an attribute ending in _id" do
      before do
        post.foo_id = 23
        post.author = User.new(username: "john_doe", first_name: "John", last_name: "Doe")
      end

      it "should call the association if one exists" do
        list = render_arbre_component assigns do
          attributes_list_for post, :author
        end
        expect(list.find_by_tag("dt").first.content).to eq "Author"
        expect(list.find_by_tag("dd").first.content).to eq "John Doe"
      end

      it "should not call an association that does not exist" do
        list = render_arbre_component assigns do
          attributes_list_for post, :foo_id
        end
        expect(list.find_by_tag("dt").first.content).to eq "Foo"
        expect(list.find_by_tag("dd").first.content).to eq "23"
      end
    end

    context "when using a single Hash" do
      let(:list) do
        render_arbre_component nil, helpers do
          attributes_list_for foo: 1, bar: 2 do
            item :foo
            item :bar
          end
        end
      end

      it "should render" do
        expect(list.find_by_tag("dt")[0].content).to eq "Foo"
        expect(list.find_by_tag("dd")[0].content).to eq "1"
        expect(list.find_by_tag("dt")[1].content).to eq "Bar"
        expect(list.find_by_tag("dd")[1].content).to eq "2"
      end
    end
  end
end
