def create_user(name, type = 'User')
  first_name, last_name = name.split(' ')
  user = type.camelize.constantize.where(first_name: first_name, last_name: last_name).first_or_create(username: name.gsub(' ', '').underscore)
end

Given /^(a|\d+)( published)? posts?(?: with the title "([^"]*)")?(?: and body "([^"]*)")?(?: written by "([^"]*)")?(?: in category "([^"]*)")? exists?$/ do |count, published, title, body, user, category_name|
  count     = count == 'a' ? 1 : count.to_i
  published = Time.now          if published
  author    = create_user(user) if user
  category  = Category.where(name: category_name).first_or_create if category_name
  title   ||= "Hello World %i"
  count.times do |i|
    Post.create! title: title % i, body: body, author: author, published_at: published, custom_category_id: category.try(:id)
  end
end

Given /^a category named "([^"]*)" exists$/ do |name|
  Category.create! name: name
end

Given /^a (user|publisher) named "([^"]*)" exists$/ do |type, name|
  create_user name, type
end

Given /^a store named "([^"]*)" exists$/ do |name|
  Store.create! name: name
end

Given /^I create a new post with the title "([^"]*)"$/ do |title|
  click_link "Posts"
  click_link "New Post"
  fill_in :title, with: title
  click_button "Create Post"
end
