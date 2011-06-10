require File.expand_path('config/environments/test', Rails.root)

# rails/railties/lib/rails/test_help.rb aborts if the environment is not 'test'. (Rails 3.0.0.beta3)
# We can't run Cucumber/RSpec/Test_Unit tests in different environments then.
#
# For now, I patch StringInquirer so that Rails.env.test? returns true when Rails.env is 'test' or 'cucumber'
#
# https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/4458-rails-should-allow-test-to-run-in-cucumber-environment
module ActiveSupport
  class StringInquirer < String
    def method_missing(method_name, *arguments)
      if method_name.to_s[-1,1] == "?"
        test_string = method_name.to_s[0..-2]
        if test_string == 'test'
          self == 'test' or self == 'cucumber'
        else
          self == test_string
        end
      else
        super
      end
    end
  end
end
