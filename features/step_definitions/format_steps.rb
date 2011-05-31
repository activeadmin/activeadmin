Then "I should see nicely formatted datetimes" do
  page.body.should =~ /\w+ \d{1,2}, \d{4} \d{2}:\d{2}/
end

Then /^I should see a link to download "([^"]*)"$/ do |format_type|
  Then %{I should see "#{format_type}" within "#index_footer a"}
end

Then /^I should see the CSV:$/ do |table|
  begin
    csv = CSV.parse(page.body)
    csv.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        expected_cell = table.raw.try(:[], row_index).try(:[], col_index)
        if expected_cell.blank?
          cell.should be_nil
        else
          cell.should match(/#{expected_cell}/)
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
