# frozen_string_literal: true
require "rails_helper"

# Scopes combined with the filter form. The rest of the scope specs are in
# spec/requests/index/index_scopes_spec.rb.
RSpec.describe "Index scopes with filters", type: :system do
  before { login_as_admin }

  def create_author(first_name, last_name)
    User.create!(first_name: first_name, last_name: last_name, username: "#{first_name}_#{last_name}".downcase)
  end

  def create_posts(count, author: nil, published: false, title: "Post")
    count.times { |i| Post.create!(title: "#{title} #{i}", author: author, published_date: (Time.current if published)) }
  end

  def click_scope(name)
    find(".scopes a", text: /\A#{Regexp.escape(name)}( \d+)?\z/, normalize_ws: true).click
  end

  it "keeps the scope selected when a filter matches nothing" do
    create_posts(3)
    register_resources do
      ActiveAdmin.register Post do
        scope :all, default: true
        filter :title
      end
    end

    visit admin_posts_path
    fill_in "Title", with: "Non Existing Post"
    click_on "Filter"

    expect(page).to have_scope("All", selected: true)
    expect(page).to have_no_css(".data-table")
  end

  it "counts each scope within the current filter" do
    daft_punk = create_author("Daft", "Punk")
    alfred = create_author("Alfred", "Smith")
    create_posts(2, author: daft_punk)
    create_posts(1, author: daft_punk, published: true)
    create_posts(1, author: alfred)
    create_posts(2, author: alfred, published: true)
    register_resources do
      ActiveAdmin.register Post do
        scope :all, default: true
        scope(:published) { |posts| posts.where.not(published_date: nil) }
      end
    end

    visit admin_posts_path

    expect(page).to have_scope("All", count: 6)
    expect(page).to have_scope("Published", count: 3)
    expect(page).to have_table_rows(6)

    click_scope("Published")

    expect(page).to have_scope("Published", count: 3, selected: true)
    expect(page).to have_scope("All", count: 6)
    expect(page).to have_css("[data-test-page-content]", text: "Active Search for Published")
    expect(page).to have_table_rows(3)

    select "Daft Punk", from: "Author"
    click_on "Filter"

    expect(page).to have_scope("Published", count: 1, selected: true)
    expect(page).to have_scope("All", count: 3)
    expect(page).to have_table_rows(1)
  end

  it "counts within scope_to and the current filter" do
    create_posts(2, author: create_author("Daft", "Punk"))
    foo_fighters = create_author("Foo", "Fighters")
    Post.create!(title: "Monkey Wrench", author: foo_fighters)
    Post.create!(title: "Everlong", author: foo_fighters)
    register_resources do
      ActiveAdmin.register Post do
        scope_to :current_user
        scope :all, default: true

        filter :title

        controller do
          def current_user
            User.find_by(username: "foo_fighters")
          end
        end
      end
    end

    visit admin_posts_path

    expect(page).to have_scope("All", count: 2, selected: true)

    fill_in "Title", with: "Monkey"
    click_on "Filter"

    expect(page).to have_scope("All", count: 1, selected: true)
    expect(page).to have_table_rows(1)
  end

  it "counts grouped collections" do
    daft_punk = create_author("Daft", "Punk")
    create_posts(2, author: daft_punk)
    create_posts(1, author: daft_punk, published: true)
    create_posts(1, author: create_author("Alfred", "Smith"))
    register_resources do
      ActiveAdmin.register Post do
        scope :all, default: true
        scope(:published) { |posts| posts.where.not(published_date: nil) }
        scope(:single) { |posts| posts.page(1).per(1) }

        index do
          column :author_id
          column :count
        end

        config.sort_order = "author_id_asc"

        controller do
          def scoped_collection
            Post.select("author_id, count(*) as count").group("author_id")
          end
        end
      end
    end

    visit admin_posts_path

    expect(page).to have_scope("All", count: 2)
    expect(page).to have_scope("Published", count: 1)
    expect(page).to have_scope("Single", count: 1)
    expect(page).to have_table_rows(2)

    click_scope("Single")

    expect(page).to have_scope("Single", selected: true)
    expect(page).to have_table_rows(1)

    click_scope("Published")

    expect(page).to have_scope("Published", count: 1, selected: true)
    expect(page).to have_scope("All", count: 2)
    expect(page).to have_table_rows(1)

    select "Daft Punk", from: "Author"
    click_on "Filter"

    expect(page).to have_scope("Published", count: 1, selected: true)
    expect(page).to have_scope("All", count: 1)
    expect(page).to have_table_rows(1)
    expect(page).to have_css("[data-test-page-content]", text: "Active Search for Published")
  end
end
