# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index scope_to", type: :request do
  before do
    10.times { |i| Post.create!(title: "Hello World #{i}") }
    author = User.create!(first_name: "John", last_name: "Doe", username: "john_doe")
    Post.create!(title: "Hello World", author: author)
    Post.create!(title: "Hello World", author: author, published_date: Time.current)
  end

  def expect_scoped_to_author
    get admin_posts_path

    expect(response_html).to have_scope("All", count: 2, selected: true)
    expect(response_html).to have_scope("Published", count: 1, selected: false)
    expect(response_html).to have_table_rows(2)

    get response_html.find(".scopes a", text: /\APublished/, normalize_ws: true)[:href]

    expect(response_html).to have_scope("Published", selected: true)
    expect(response_html).to have_table_rows(1)
  end

  it "scopes the collection and its scope counts with a block" do
    register_resources do
      ActiveAdmin.register Post do
        scope_to { User.find_by(first_name: "John", last_name: "Doe") }

        scope :all, default: true
        scope(:published) { |posts| posts.where.not(published_date: nil) }
      end
    end

    expect_scoped_to_author
  end

  it "scopes the collection and its scope counts with a proc" do
    register_resources do
      ActiveAdmin.register Post do
        scope_to -> { User.find_by(first_name: "John", last_name: "Doe") }

        scope :all, default: true
        scope(:published) { |posts| posts.where.not(published_date: nil) }
      end
    end

    expect_scoped_to_author
  end

  it "doesn't scope when the if: condition is false" do
    register_resources do
      ActiveAdmin.register Post do
        scope_to(if: proc { false }) { User.find_by(first_name: "John", last_name: "Doe") }
      end
    end

    get admin_posts_path

    expect(response_html).to have_table_rows(12)
  end

  it "doesn't scope when the unless: condition is true" do
    register_resources do
      ActiveAdmin.register Post do
        scope_to(unless: proc { true }) { User.find_by(first_name: "John", last_name: "Doe") }
      end
    end

    get admin_posts_path

    expect(response_html).to have_table_rows(12)
  end
end
