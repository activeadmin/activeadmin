require 'csv'

Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should( not)? see a link to download "([^"]*)"$/ do |negate, format|
  method = negate ? :should_not : :should
  page.send method, have_css("#index_footer a", :text => format)
end

# Check first rows of the displayed CSV.
Then /^I should download a CSV file with "([^"]*)" separator for "([^"]*)" containing:$/ do |sep, resource_name, table|
  body    = page.driver.response.body
  headers = page.response_headers
  headers['Content-Type'].should        eq 'text/csv; charset=utf-8'
  headers['Content-Disposition'].should eq %{attachment; filename="#{resource_name}-#{Time.now.strftime("%Y-%m-%d")}.csv"}

  begin
    csv = CSV.parse(body, :col_sep => sep)
    table.raw.each_with_index do |expected_row, row_index|
      expected_row.each_with_index do |expected_cell, col_index|
        cell = csv.try(:[], row_index).try(:[], col_index)
        if expected_cell.blank?
          cell.should be_nil
        else
          (cell || '').should match /#{expected_cell}/
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
  page.driver.response.body.should match /"#{text}"/
end
