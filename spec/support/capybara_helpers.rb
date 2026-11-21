# frozen_string_literal: true

# Capybara helpers for request and system specs. Matchers work on a system
# spec's `page` and on a request spec's `response_html`.
module CapybaraHelpers
  # Matches the title in the page header, e.g.
  #   expect(page).to have_page_title("Posts")
  def have_page_title(title)
    have_css("[data-test-page-header] h2", exact_text: title)
  end

  # Matches the exact normalized label and value in an attributes table, e.g.
  #   expect(page).to have_attributes_table_text("Title", "Hello World")
  def have_attributes_table_text(title, value)
    xpath = XPath.descendant[XPath.attr(:class).contains_word("attributes-table")]
      .descendant(:th)[XPath.string.n.equals(title)]
      .following_sibling(:td)[XPath.string.n.equals(value)]

    have_xpath(xpath)
  end

  # Matches an index page's link to download the given format, e.g.
  #   expect(page).to have_download_link("CSV")
  # The link must say the format and point at a URL with its extension.
  def have_download_link(format)
    have_link(format, exact: true, href: /\.#{format.downcase}(\?|\z)/)
  end

  # The response body as a Capybara node, so request specs can use the same
  # matchers as system specs:
  #   expect(response_html).to have_page_title("Posts")
  def response_html
    Capybara.string(response.body)
  end
end

RSpec.configure do |config|
  # System specs get these from capybara/rspec. Without them, `have_css` in a
  # request spec falls back to RSpec's predicate matcher, whose failure
  # message is only "expected ... to be truthy, got false".
  config.include Capybara::RSpecMatchers, type: :request
  config.include CapybaraHelpers, type: :request
  config.include CapybaraHelpers, type: :system
end
