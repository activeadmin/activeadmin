Then /^"(.*?)" shouldn't be a symbol$/ do |sym|
  Symbol.all_symbols.map(&:to_s).should_not include(sym), 'symbol detected!'
end
