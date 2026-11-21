# frozen_string_literal: true
Then(/^I should( not)? see the attribute "([^"]*)" with "([^"]*)"$/) do |negate, title, value|
  elems = all ".attributes-table th:contains('#{title}') ~ td:contains('#{value}')"

  if negate
    expect(elems.first).to eq(nil), "attribute missing"
  else
    expect(elems.first).to_not eq(nil), "attribute missing"
  end
end
