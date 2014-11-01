Then /^"(.*?)" shouldn't be a symbol$/ do |sym|
  expect(Symbol.all_symbols.map &:to_s).to_not include(sym), 'symbol detected!'
end
