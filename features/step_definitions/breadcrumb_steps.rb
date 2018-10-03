Around '@breadcrumb' do |scenario, block|
  previous_breadcrumb = ActiveAdmin.application.breadcrumb

  begin
    block.call
  ensure
    ActiveAdmin.application.breadcrumb = previous_breadcrumb
  end
end

Then /^I should see a link to "([^"]*)" in the breadcrumb$/ do |text|
  expect(page).to have_css '.breadcrumb > a', text: text
end
