Then "I should see the context sentence '$sentence'" do |sentence|
  with_scope('".context_sentence"') do
    page.should have_content(sentence)
  end
end
