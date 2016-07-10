Then /^I should see (\d+) ([\w]*) in the table$/ do |count, resource_type|
  expect(page).to \
    have_css("table.index_table tr > td:first-child", count: count.to_i)
end

# TODO: simplify this, if possible?
class HtmlTableToTextHelper
  def initialize(html, table_css_selector = "table")
    @html = html
    @selector = table_css_selector
  end

  def to_array
    rows = Nokogiri::HTML(@html).css("#{@selector} tr")
    rows.map do |row|
      row.css('th, td').map do |td|
        cell_to_string(td)
      end
    end
  end

  private

  def cell_to_string(td)
    str = ""
    input = td.css('input').last

    if input
      str << input_to_string(input)
    end

    str << td.content.strip.gsub("\n", ' ')
  end

  def input_to_string(input)
    case input.attribute("type").value
    when "checkbox"
      if input.attribute("disabled")
        "_"
      else
        if input.attribute("checked")
          "[X]"
        else
          "[ ]"
        end
      end
    when "text"
      if input.attribute("value").present?
        "[#{input.attribute("value")}]"
      else
        "[ ]"
      end
    when "submit"
      input.attribute("value")
    else
      raise "I don't know what to do with #{input}"
    end
  end
end

module TableMatchHelper
  # @param table [Array[Array]]
  # @param expected_table [Array[Array[String]]]
  # The expected_table values are String. They are converted to
  # Regexp when they start and end with a '/'
  # Example:
  #
  #   assert_table_match(
  #     [["Name", "Date"], ["Philippe", "Feb 08"]],
  #     [["Name", "Date"], ["Philippe", "/\w{3} \d{2}/"]]
  #   )
  def assert_tables_match(table, expected_table)
    expected_table.each_index do |row_index|
      expected_table[row_index].each_index do |column_index|
        expected_cell = expected_table[row_index][column_index]
        cell = table.try(:[], row_index).try(:[], column_index)
        begin
          assert_cells_match(cell, expected_cell)
        rescue
          puts "Cell at line #{row_index} and column #{column_index}: #{cell.inspect} does not match #{expected_cell.inspect}"
          puts "Expecting:"
          table.each { |row| puts row.inspect }
          puts "to match:"
          expected_table.each { |row| puts row.inspect }
          raise $!
        end
      end
    end
  end

  def assert_cells_match(cell, expected_cell)
    if expected_cell =~ /^\/.*\/$/
      expect(cell).to match /#{expected_cell[1..-2]}/
    else
      expect((cell || "").strip).to eq expected_cell
    end
  end
end

World(TableMatchHelper)

# Usage:
#
#   I should see the "invoices" table:
#     | Invoice #    | Date     | Total Amount |
#     |    /\d+/     | 27/01/12 |       $30.00 |
#     |    /\d+/     | 12/02/12 |       $25.00 |
#
Then /^I should see the "([^"]*)" table:$/ do |table_id, expected_table|
  expect(page).to have_css "table##{table_id}"

  assert_tables_match(
    HtmlTableToTextHelper.new(page.body, "table##{table_id}").to_array,
    expected_table.raw
  )
end
