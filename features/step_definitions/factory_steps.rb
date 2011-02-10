Given /^a post with the title "([^"]*)" exists$/ do |title|
  Post.create! :title => title
end

Given /^a post with the title "([^"]*)" and body "([^"]*)" exists$/ do |title, body|
  Post.create! :title => title, :body => body
end
