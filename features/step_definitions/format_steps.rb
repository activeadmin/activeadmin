require 'csv'

Then "I should see nicely formatted datetimes" do
  expect(page.body).to match /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should( not)? see a link to download "([^"]*)"$/ do |negate, format|
  method = negate ? :to_not : :to
  expect(page).send method, have_css("#index_footer a", text: format)
end

# Check first rows of the displayed CSV.
Then /^I should download a CSV file with "([^"]*)" separator for "([^"]*)" containing:$/ do |sep, resource_name, table|
  body   = page.driver.response.body
  header = page.response_headers['Content-Type']
  expect(header).to eq 'text/csv; charset=utf-8'

  begin
    csv = CSV.parse(body, col_sep: sep)
    table.raw.each_with_index do |expected_row, row_index|
      expected_row.each_with_index do |expected_cell, col_index|
        cell = csv.try(:[], row_index).try(:[], col_index)
        if expected_cell.blank?
          expect(cell).to be_nil
        else
          expect(cell || '').to match /#{expected_cell}/
        end
      end
    end
  rescue
    puts "Expecting:"
    p table.raw
    puts "to match:"
    p csv
    raise $!
  end
end

Then /^I should download a CSV file for "([^"]*)" containing:$/ do |resource_name, table|
  step %{I should download a CSV file with "," separator for "#{resource_name}" containing:}, table
end

Then /^the CSV file should contain "([^"]*)" in quotes$/ do |text|
  expect(page.driver.response.body).to match /"#{text}"/
end

Then /^the encoding of the CSV file should be "([^"]*)"$/ do |text|
  expect(page.driver.response.body.encoding).to be Encoding.find(Encoding.aliases[text] || text)
end
