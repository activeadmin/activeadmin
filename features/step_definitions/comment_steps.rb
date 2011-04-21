Then /^I should see a comment by "([^"]*)"$/ do |name|
  Then %{I should see "#{name}" within ".active_admin_comment_author"}
end

When /^I add a comment "([^"]*)"$/ do |comment|
  When %{I fill in "active_admin_comment_body" with "#{comment}"}
  And  %{I press "Add Comment"}
end
