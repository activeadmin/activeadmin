Then /^I (should|should not) see the batch action "([^"]*)"$/ do |maybe, title|
  %{Then I #{maybe} see the batch action :#{title.gsub(' ','').gsub(" Selected", "").underscore} "#{title}"}
end

Then /^I (should|should not) be asked to confirm "([^"]*)" for "([^"]*)"$/ do |maybe, confirmation, title|
  within "#batch_actions_popover" do
    unless maybe == "should not"
      link = page.find "a.batch_action", :text => title
      link["data-request-confirm"].should match( confirmation )
    else
      page.should_not have_css("a.batch_action", :text => title)
    end
  end
end

Then /^I (should|should not) see the batch action :([^\s]*) "([^"]*)"$/ do |maybe, sym, title|
  within "#batch_actions_popover" do
    unless maybe == "should not"
      link = page.find "a.batch_action", :text => title
      link["data-action"].should match( sym )
      link[:href].should match( "#" )
    else
      page.should_not have_css("a.batch_action", :text => title)
    end
  end
end

Then /^the (\d+)(?:st|nd|rd|th) batch action should be "([^"]*)"$/ do |index, title|
  within "#batch_actions_popover" do
    page.all( "a.batch_action" )[index.to_i - 1].text.should match( title )
  end
end 

When /^I check the (\d+)(?:st|nd|rd|th) record$/ do |index|
  page.all( "table.index_table input[type=checkbox]" )[index.to_i - 1].set( true )
end

When /^I uncheck the (\d+)(?:st|nd|rd|th) record$/ do |index|
  page.all( "table.index_table input[type='checkbox']" )[index.to_i - 1].set( false )
end

When /^I toggle the collection selection$/ do 
  toggle_box = page.find( "#collection_selection_toggle_all" )
  toggle_box.click
end

Then /^I should see (\d+) record(?:s)? selected$/ do |count|
  within "table.index_table" do
    unless count.to_i == 0
      page.should have_xpath(".//input[@type='checkbox' and @checked='checked']", :count => count)
    else 
      page.should have_no_xpath(".//input[@type='checkbox' and @checked='checked']")
    end
  end
end

Then /^I should see that the batch action button is disabled$/ do
  page.should have_css("#batch_actions_button.disabled")
end

Then /^I should see the batch action button$/ do 
  page.should have_css("div.table_tools #batch_actions_button")
end

Then /^I should see the batch action popover exist$/ do
  page.should have_css("#batch_actions_popover")
end