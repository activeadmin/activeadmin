# frozen_string_literal: true
def create_user(name, type = "User")
  first_name, last_name = name.split(" ")
  type.camelize.constantize.where(first_name: first_name, last_name: last_name).first_or_create(username: name.tr(" ", "").underscore)
end

Given(/^(a|\d+)( published)?( unstarred| starred)? posts?(?: with the title "([^"]*)")?(?: and body "([^"]*)")?(?: written by "([^"]*)")?(?: in category "([^"]*)")? exists?$/) do |count, published, starred, title, body, user, category_name|
  count = count == "a" ? 1 : count.to_i
  published = Time.now if published
  starred = starred == " starred" if starred
  author = create_user(user) if user
  category = Category.where(name: category_name).first_or_create if category_name
  title ||= "Hello World %i"
  count.times do |i|
    Post.create! title: title % i, body: body, author: author, published_date: published, custom_category_id: category.try(:id), starred: starred
  end
end
