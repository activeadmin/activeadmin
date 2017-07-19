Then /^I should see a comment by "([^"]*)"$/ do |name|
  step %{I should see "#{name}" within ".active_admin_comment_author"}
end

When /^I add a comment "([^"]*)"$/ do |comment|
  step %{I fill in "active_admin_comment_body" with "#{comment}"}
  step %{I press "Add Comment"}
end

Given /^a tag with the name "([^"]*)" exists$/ do |tag_name|
  Tag.create(name: tag_name)
end

Given /^(a|\d+) comments added by admin with an email "([^"]+)"?$/ do |number, email|
  number = number == 'a' ? 1 : number.to_i
  admin_user = ensure_user_created(email)

  comment_text = 'Comment %i'

  number.times do |i|
    ActiveAdmin::Comment.create!(namespace:     'admin',
                                 body:          comment_text % i,
                                 resource_type: Post.to_s,
                                 resource_id:   Post.first.id,
                                 author_type:   admin_user.class.to_s,
                                 author_id:     admin_user.id)
  end
end

Then /^I should see (\d+) comments?$/ do |number|
  expect(page).to have_selector('div.active_admin_comment', count: number.to_i)
end
