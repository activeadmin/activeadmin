# frozen_string_literal: true
require "rails_helper"

RSpec.describe CapybaraHelpers do
  include Capybara::RSpecMatchers
  include CapybaraHelpers

  let(:html) do
    Capybara.string(<<~HTML)
      <table class="attributes-table">
        <tr><th>Title</th><td><a href="/">Hello World</a></td></tr>
        <tr><th>Sign In Count</th><td>10</td></tr>
      </table>
    HTML
  end

  it "matches exact normalized text, including linked values" do
    expect(html).to have_attributes_table_text("Title", "Hello World")
  end

  it "rejects values with unexpected trailing text" do
    expect(html).not_to have_attributes_table_text("Title", "Hello")
  end

  it "rejects different numeric values containing the expected digit" do
    expect(html).not_to have_attributes_table_text("Sign In Count", "0")
  end

  it "matches attribute labels exactly" do
    expect(html).not_to have_attributes_table_text("Count", "10")
  end

  describe "#have_breadcrumb_link" do
    it "matches an exact link label and destination in the breadcrumb" do
      node = Capybara.string('<nav aria-label="breadcrumb"><a href="/posts">Posts</a></nav>')

      expect(node).to have_breadcrumb_link("Posts", href: "/posts")
      expect(node).not_to have_breadcrumb_link("Post")
      expect(node).not_to have_breadcrumb_link("Posts", href: "/users")
    end

    it "rejects matching links outside the breadcrumb" do
      node = Capybara.string(<<~HTML)
        <a href="/posts">Posts</a>
        <nav aria-label="breadcrumb"><a href="/users">Users</a></nav>
      HTML

      expect(node).not_to have_breadcrumb_link("Posts", href: "/posts")
    end

    it "rejects anchors without a destination" do
      node = Capybara.string('<nav aria-label="breadcrumb"><a>Posts</a></nav>')

      expect(node).not_to have_breadcrumb_link("Posts")
    end
  end
end
