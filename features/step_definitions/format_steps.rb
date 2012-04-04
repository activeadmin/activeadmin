CSVLib = if RUBY_VERSION =~ /^1.8/
            require 'fastercsv'
            FasterCSV
          else
            require 'csv'
            CSV
          end

Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should see a link to download "([^"]*)"$/ do |format_type|
  page.should have_css("#index_footer a", :text => format_type)
end

Then /^I should not see a link to download "([^"]*)"$/ do |format_type|
  page.should_not have_css("#index_footer a", :text => format_type)
end

# Check first rows of the displayed CSV.
Then /^I should download a CSV file with "([^"]*)" separator for "([^"]*)" containing:$/ do |sep, resource_name, table|
  page.response_headers['Content-Type'].should == 'text/csv; charset=utf-8'
  csv_filename = "#{resource_name}-#{Time.now.strftime("%Y-%m-%d")}.csv"
  page.response_headers['Content-Disposition'].should == %{attachment; filename="#{csv_filename}"}
  body = page.driver.response.body

  begin
    csv = CSVLib.parse(body, :col_sep => sep)
    table.raw.each_with_index do |expected_row, row_index|
      expected_row.each_with_index do |expected_cell, col_index|
        cell = csv.try(:[], row_index).try(:[], col_index)
        if expected_cell.blank?
          cell.should be_nil
        else
          (cell || '').should match(/#{expected_cell}/)
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
