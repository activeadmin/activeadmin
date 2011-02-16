Given /^a post with the title "([^"]*)" exists$/ do |title|
  Post.create! :title => title
end

Given /^a post with the title "([^"]*)" and body "([^"]*)" exists$/ do |title, body|
  Post.create! :title => title, :body => body
end

Given /^(\d+) posts exist/ do |count|
  (0...count.to_i).each do |i|
    Post.create! :title => "Hello World #{i}"
  end
end
