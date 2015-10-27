source "http://rubygems.org"

# Lowest Precedence First, Gemspec => Gemfile => gemfiles/Gemfile.rails-D.D.x
gemspec :path => ".."

# The only gems that change with version of Rails being tested are:
gem "rails",                                "~> 4.1.0"
gem "jquery-ui-rails",                      ">= 5.0"
gem "shoulda-matchers",                     "~> 3.0",   group: :test

# The following gems do not change with version of Rails being tested.
# If they are also listed in the gemspec the version will not be specified here.
gem "rake",                                             require: false

# The next set are listed here to restrict the platform.
# Gems that need a platform restriction can never be added
#   to the .gemspec as dependencies because bundler would attempt to install on all platforms.
gem "sqlite3",                              "~> 1.3",   platforms: [:ruby]
gem "activerecord-mysql2-adapter",                      platforms: [:ruby]
gem "pg",                                               platforms: [:ruby]
gem "activerecord-jdbcsqlite3-adapter",     "~> 1.3",   platforms: [:jruby]
gem "activerecord-jdbcmysql-adapter",       "~> 1.3",   platforms: [:jruby]
gem "activerecord-jdbcpostgresql-adapter",  "~> 1.3",   platforms: [:jruby]

group :development do
  # Debugging
  gem "binding_of_caller",                              platforms: [:mri] # Retrieve the binding of a method's caller in MRI Ruby >= 1.9.2

  # Performance
  gem "flamegraph",                                     platforms: [:mri] # Flamegraph visualiztion: ?pp=flamegraph

  # Documentation
  gem "redcarpet",                                      platforms: [:mri] # Markdown implementation (for yard)
  gem "kramdown",                           "~> 1.9",   platforms: [:jruby] # Markdown implementation (for yard)
  gem "stackprof",                          "~> 0.2",   platforms: [:ruby] # Actually only Ruby 2.1+, but activeadmin no longer supports Ruby 2.0, so :/
end

group :test do
  gem "simplecov",                                      require: false # Test coverage generator. Go to /coverage/ after running tests
  gem "coveralls",                                      require: false # Test coverage website. Go to https://coveralls.io
  gem "cucumber-rails",                                 require: false
end
