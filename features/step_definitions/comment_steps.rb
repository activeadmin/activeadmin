# frozen_string_literal: true
Then /^I should see a comment by "([^"]*)"$/ do |name|
  step %{I should see "#{name}" within ".active_admin_comment_author"}
end

Then /^I should( not)? be able to add a comment$/ do |negate|
  should = negate ? :not_to : :to
  expect(page).send should, have_button("Add Comment")
end

When /^I add a comment "([^"]*)"$/ do |comment|
  step %{I fill in "active_admin_comment_body" with "#{comment}"}
  step %{I press "Add Comment"}
end

Given /^(a|\d+) comments added by admin with an email "([^"]+)"?$/ do |number, email|
  number = number == "a" ? 1 : number.to_i
  admin_user = ensure_user_created(email)

  comment_text = "Comment %i"

  number.times do |i|
    ActiveAdmin::Comment.create!(
      namespace: "admin",
      body: comment_text % i,
      resource_type: Post.to_s,
      resource_id: Post.first.id,
      author_type: admin_user.class.to_s,
      author_id: admin_user.id)
  end
end

Then /^I should see (\d+) comments?$/ do |number|
  expect(page).to have_selector("div.active_admin_comment", count: number.to_i)
end
