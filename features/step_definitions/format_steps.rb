require 'csv'

Around '@csv' do |scenario, block|
  default_csv_options = ActiveAdmin.application.csv_options

  begin
    block.call
  ensure
    ActiveAdmin.application.csv_options = default_csv_options
  end
end

Then "I should see nicely formatted datetimes" do
  expect(page.body).to match /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should( not)? see a link to download "([^"]*)"$/ do |negate, format|
  method = negate ? :to_not : :to
  expect(page).send method, have_css("#index_footer a", text: format)
end

# Check first rows of the displayed CSV.
Then /^I should download a CSV file with "([^"]*)" separator for "([^"]*)" containing:$/ do |sep, resource_name, table|
  body = page.driver.response.body
  content_type_header, content_disposition_header = %w[Content-Type Content-Disposition].map do |header_name|
    page.response_headers[header_name]
  end
  expect(content_type_header).to eq 'text/csv; charset=utf-8'
  expect(content_disposition_header).to match /\Aattachment; filename=".+?\.csv"\z/

  csv = CSV.parse(body, col_sep: sep)
  table.raw.each_with_index do |expected_row, row_index|
    expected_row.each_with_index do |expected_cell, col_index|
      cell = csv.try(:[], row_index).try(:[], col_index)
      if expected_cell.blank?
        expect(cell).to eq nil
      else
        expect(cell || '').to match /#{expected_cell}/
      end
    end
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

Then /^access denied$/ do
  expect(page).to have_content(I18n.t("active_admin.access_denied.message"))
end
