Given /^a post with the title "([^"]*)" exists$/ do |title|
  Post.create! :title => title
end
