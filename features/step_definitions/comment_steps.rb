Then /^I should see a comment by "([^"]*)"$/ do |name|
  step %{I should see "#{name}" within ".active_admin_comment_author"}
end

When /^I add a comment "([^"]*)"$/ do |comment|
  step %{I fill in "active_admin_comment_body" with "#{comment}"}
  step  %{I press "Add Comment"}
end


Given /^a tag with the name "([^"]*)" exists$/ do |tag_name|
  Tag.create(:name => tag_name)
end
