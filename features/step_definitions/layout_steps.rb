Then /^I should see the Active Admin layout$/ do
  expect(page).to have_css '#active_admin_content #main_content_wrapper'
end
