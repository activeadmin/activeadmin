# frozen_string_literal: true
require "rails_helper"

# Scopes with the filter form are in spec/system/index/index_scopes_spec.rb.
RSpec.describe "Index scopes", type: :request do
  def create_posts(count, published: false)
    count.times { |i| Post.create!(title: "Post #{i}", published_date: (Time.current if published)) }
  end

  def register_post(&block)
    register_resources { ActiveAdmin.register(Post, &block) }
  end

  def follow_scope(name)
    get response_html.find(".scopes a", text: /\A#{Regexp.escape(name)}( \d+)?\z/, normalize_ws: true)[:href]
  end

  def have_active_search_for(name)
    have_css("[data-test-page-content]", text: "Active Search for #{name}")
  end

  describe "a single scope" do
    before { create_posts(3) }

    it "isn't selected when it's not the default" do
      register_post { scope :all }

      get admin_posts_path

      expect(response_html).to have_scope("All", count: 3, selected: false)
      expect(response_html).to have_table_rows(3)
    end

    it "is selected when it's the default" do
      register_post { scope :all, default: true }

      get admin_posts_path

      expect(response_html).to have_scope("All", count: 3, selected: true)
      expect(response_html).to have_table_rows(3)
    end

    it "isn't selected when its default proc returns false" do
      register_post { scope :all, default: proc { false } }

      get admin_posts_path

      expect(response_html).to have_scope("All", count: 3, selected: false)
      expect(response_html).to have_table_rows(3)
    end

    it "takes its name from a proc" do
      register_post do
        scope -> { scope_title }, :all

        controller do
          def scope_title
            "Neat scope"
          end

          helper_method :scope_title
        end
      end

      get admin_posts_path

      expect(response_html).to have_scope("Neat scope")
      expect(response_html).to have_table_rows(3)

      follow_scope("Neat scope")

      expect(response_html).to have_table_rows(3)
      expect(response_html).to have_active_search_for("Neat scope")
    end

    it "shows no count when the index turns scope counts off" do
      register_post do
        scope :all, default: true
        index as: :table, scope_count: false
      end

      get admin_posts_path

      expect(response_html).to have_scope("All", count: false, selected: true)
      expect(response_html).to have_no_css(".scopes-count")
      expect(response_html).to have_table_rows(3)
    end

    it "shows no count when the scope turns it off" do
      register_post { scope :all, default: true, show_count: false }

      get admin_posts_path

      expect(response_html).to have_scope("All", count: false, selected: true)
      expect(response_html).to have_no_css(".scopes-count")
      expect(response_html).to have_table_rows(3)
    end
  end

  it "counts and filters records for each scope" do
    create_posts(2)
    create_posts(3, published: true)
    register_post do
      scope :all, default: true
      scope(:published) { |posts| posts.where.not(published_date: nil) }
    end

    get admin_posts_path

    expect(response_html).to have_scope("All", count: 5)
    expect(response_html).to have_scope("Published", count: 3)
    expect(response_html).to have_table_rows(5)

    follow_scope("Published")

    expect(response_html).to have_scope("Published", selected: true)
    expect(response_html).to have_active_search_for("Published")
    expect(response_html).to have_table_rows(3)
  end

  describe "conditional scopes" do
    before { create_posts(3) }

    it "shows only scopes whose condition passes" do
      register_post do
        scope :all, if: proc { false }
        scope("Shown", if: proc { true }) { |posts| posts }
        scope("Shown with lambda", if: -> { true }) { |posts| posts }
        scope("Shown with method name", if: :neat_scope?) { |posts| posts }
        scope("Default", default: true) { |posts| posts }
        scope("Today", if: proc { false }) { |posts| posts }

        controller do
          def neat_scope?
            true
          end

          helper_method :neat_scope?
        end
      end

      get admin_posts_path

      expect(response_html).to have_scope("Default", count: 3, selected: true)
      expect(response_html).to have_scope("Shown")
      expect(response_html).to have_scope("Shown with lambda")
      expect(response_html).to have_scope("Shown with method name")
      expect(response_html).not_to have_scope("All")
      expect(response_html).not_to have_scope("Today")
    end

    it "shows no scopes when every condition fails" do
      register_post do
        scope :all, if: proc { false }
        scope(:hidden, if: proc { false }) { |posts| posts }
        scope(:hidden_as_well, if: proc { false }) { |posts| posts }
      end

      get admin_posts_path

      expect(response_html).to have_table_rows(3)
      expect(response_html).to have_no_css(".scopes a")
    end
  end

  it "switches between block scopes" do
    create_posts(3)
    register_post do
      scope("Today", default: true) do |posts|
        posts.where(created_at: Time.zone.now.all_day)
      end
      scope("Tomorrow") do |posts|
        posts.where(created_at: (Time.zone.now + 1.day).all_day)
      end
    end

    get admin_posts_path

    expect(response_html).to have_scope("Today", count: 3, selected: true)
    expect(response_html).to have_scope("Tomorrow", count: 0, selected: false)
    expect(response_html).to have_table_rows(3)

    follow_scope("Tomorrow")

    expect(response_html).to have_scope("Tomorrow", selected: true)
    expect(response_html).to have_scope("Today", selected: false)
    expect(response_html).to have_active_search_for("Tomorrow")
  end

  it "groups scopes" do
    create_posts(3)
    register_post do
      scope :all
      scope("Published", group: :status) { |posts| posts.where.not(published_date: nil) }
      scope("Unpublished", group: :status) { |posts| posts.where(published_date: nil) }
      scope("Today", group: :date) { |posts| posts.where(created_at: Time.zone.now.all_day) }
      scope("Tomorrow", group: :date) { |posts| posts.where(created_at: (Time.zone.now + 1.day).all_day) }
    end

    get admin_posts_path

    groups = response_html.all(".scopes [data-group]").to_h do |group|
      [group["data-group"], group.all("a").map { |link| link.text(normalize_ws: true).sub(/ \d+\z/, "") }]
    end
    expect(groups).to eq(
      "default" => ["All"],
      "status" => ["Published", "Unpublished"],
      "date" => ["Today", "Tomorrow"]
    )
  end
end
