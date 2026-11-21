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
end
