Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should see a link to download "([^"]*)"$/ do |format_type|
  Then %{I should see "#{format_type}" within "#index_footer a"}
end

require 'csv'

Then /^I should see the CSV:$/ do |table|
  puts page.body
  csv = CSV.parse(page.body)
  csv.each_with_index do |row, row_index|
	row.each_with_index do |cell, col_index|
	  cell.should match(/#{table.raw[row_index][col_index]}/)
	end
  end
end
