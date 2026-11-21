# frozen_string_literal: true

# Capybara helpers for request and system specs. Matchers work on a system
# spec's `page` and on a request spec's `response_html`.
module CapybaraHelpers
  # Matches the title in the page header, e.g.
  #   expect(page).to have_page_title("Posts")
  def have_page_title(title)
    have_css("[data-test-page-header] h2", exact_text: title)
  end

  # Matches a link in the page header's breadcrumb, e.g.
  #   expect(page).to have_breadcrumb_link("Posts", href: admin_posts_path)
  def have_breadcrumb_link(text, **options)
    have_link(text, exact: true, **options) do |link|
      link.has_ancestor?("nav[aria-label=breadcrumb]", wait: 0)
    end
  end

  # Matches the exact normalized label and value in an attributes table, e.g.
  #   expect(page).to have_attributes_table_text("Title", "Hello World")
  def have_attributes_table_text(title, value)
    xpath = XPath.descendant[XPath.attr(:class).contains_word("attributes-table")]
      .descendant(:th)[XPath.string.n.equals(title)]
      .following_sibling(:td)[XPath.string.n.equals(value)]

    have_xpath(xpath)
  end

  # Matches a table header cell by its exact text. With `sortable: true`, it
  # must also be sortable, e.g.
  #   expect(page).to have_table_header("Title", sortable: true)
  def have_table_header(text, sortable: false)
    have_css(sortable ? "th[data-sortable]" : "th", exact_text: text)
  end

  # Matches a link in an index table row's actions column, e.g.
  #   expect(page).to have_member_link("View", href: admin_post_path(post))
  def have_member_link(text, **options)
    have_link(text, exact: true, **options) do |link|
      link.find(:xpath, "..", wait: 0).matches_css?(".data-table-resource-actions", wait: 0)
    end
  end

  # Matches an index page's link to download the given format, e.g.
  #   expect(page).to have_download_link("CSV")
  # The link must say the format and point at a URL with its extension.
  def have_download_link(format)
    have_link(format, exact: true, href: /\.#{format.downcase}(\?|\z)/)
  end

  # Returns a table's rows as arrays of cell text, header row included, so
  # a whole table can be compared at once. A checkbox in a cell reads as
  # "[ ]". Compare with `match` to use regexes for cells that vary:
  #
  #   expect(table_rows(page, "#index_table_posts")).to match([
  #     ["Id", "Title", "Created At"],
  #     ["1", "Hello World", /\d{4}/]
  #   ])
  def table_rows(container, selector)
    container.find(selector).all("tr").map do |row|
      row.all("th, td").map do |cell|
        checkbox = cell.has_css?("input[type=checkbox]", wait: false) ? "[ ]" : ""
        checkbox + cell.text(normalize_ws: true)
      end
    end
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
