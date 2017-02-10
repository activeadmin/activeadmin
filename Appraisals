appraise 'rails_32' do
  gemspec

  gem 'rails', '3.2.22'
  gem 'jquery-ui-rails', '~> 4.0'
  gem 'devise', '~> 3.5'

  gem 'inherited_resources'

  gem 'test-unit', '~> 3.0'

  gem 'draper', '~> 2.1'

  platforms :ruby_19 do # Remove this block when we drop support for Ruby 1.9
    gem 'kaminari', '~> 0.15'
    gem 'mime-types', '< 3'
    gem 'nokogiri', '< 1.7'
    gem 'public_suffix', '< 1.5'
  end
end

appraise 'rails_40' do
  gemspec

  gem 'rails', '4.0.13'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'devise', '~> 3.5'

  gem 'inherited_resources'

  gem 'draper', '~> 2.1'

  platforms :ruby_19 do # Remove this block when we drop support for Ruby 1.9
    gem 'kaminari', '~> 0.15'
    gem 'mime-types', '< 3'
    gem 'nokogiri', '< 1.7'
    gem 'public_suffix', '< 1.5'
  end
end

appraise 'rails_41' do
  gemspec

  gem 'rails', '4.1.16'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'devise', '~> 3.5'

  gem 'inherited_resources'

  gem 'draper', '~> 2.1'

  platforms :ruby_19 do # Remove this block when we drop support for Ruby 1.9
    gem 'kaminari', '~> 0.15'
    gem 'mime-types', '< 3'
    gem 'nokogiri', '< 1.7'
    gem 'public_suffix', '< 1.5'
  end
end

appraise 'rails_42' do
  gemspec

  gem 'rails', '4.2.8.rc1'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'devise', '~> 3.5'

  gem 'inherited_resources'

  gem 'draper', '~> 2.1'

  platforms :ruby_19 do # Remove this block when we drop support for Ruby 1.9
    gem 'kaminari', '~> 0.15'
    gem 'mime-types', '< 3'
    gem 'nokogiri', '< 1.7'
    gem 'public_suffix', '< 1.5'
  end
end

appraise 'rails_50' do
  gemspec

  gem 'rails', '5.0.1'
  gem 'jquery-ui-rails', '~> 5.0'
  gem 'devise', '> 4.x'

  # Note: when updating this list, be sure to also update the README
  gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'

  gem 'draper', '> 3.x'
end
