Given /^a post with the title "([^"]*)" exists$/ do |title|
  Post.create! :title => title
end

Given /^a post with the title "([^"]*)" and body "([^"]*)" exists$/ do |title, body|
  Post.create! :title => title, :body => body
end

Given /^a post with the title "([^"]*)" written by "([^"]*)" exists$/ do |title, author_name|
  first, last = author_name.split(' ')
  author = User.find_or_create_by_first_name_and_last_name(first, last, :username => author_name.gsub(' ', '').underscore)
  Post.create! :title => title, :author => author
end

Given /^(\d+)( published)? posts? exists?$/ do |count, published|
  (0...count.to_i).each do |i|
    Post.create! :title => "Hello World #{i}", :published_at => (published ? Time.now : nil)
  end
end

Given /^a category named "([^"]*)" exists$/ do |name|
  Category.create! :name => name
end

Given /^a (user|publisher) named "([^"]*)" exists$/ do |type, name|
  first, last = name.split(" ")
  type = type.camelize.constantize
  type.create! :first_name => first, :last_name => last, :username => name
end
