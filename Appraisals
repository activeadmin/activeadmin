appraise 'rails-3' do
  gem 'rails', '3.2.22'
  gem 'jquery-ui-rails', '~> 4.0'
  gem 'test-unit', '~> 3.0'
  gem 'draper'
  gem 'devise', '~> 3.5'
end

appraise 'rails-4' do
  gem 'rails', '4.2.5'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'draper'
  gem 'devise', '~> 3.5'
end

appraise 'rails-5' do
  gem 'rails', '5.0.0'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'devise', '> 4.x'

  # Note: when updating this list, be sure to also update the README
  gem 'ransack',    github: 'activerecord-hackery/ransack'
  gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
  gem 'draper',     github: 'audionerd/draper', branch: 'rails5', ref: 'e816e0e587'
  gem 'formtastic', github: 'justinfrench/formtastic'
  gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml' # drapergem/draper#697
end
