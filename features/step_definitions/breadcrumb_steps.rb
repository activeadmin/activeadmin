Then /^I should see a link to "([^"]*)" in the breadcrumb$/ do |text|
  within ".breadcrumb" do
    page.should have_css("a", :text => text)
  end
end
