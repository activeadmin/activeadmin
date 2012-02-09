Then /^I should see the posts ordered by (descending|ascending) "([^"]*)"$/ do |order, attribute|
  order = (order == 'descending') ? 'desc' : 'asc'
  titles = Post.select(:title).order("#{attribute} #{order}").map(&:title)
  page.html.should =~ /#{titles.join('.*')}/m
end
