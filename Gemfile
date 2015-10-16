source "https://rubygems.org"

gemspec

# VALID REASONS TO ADD A GEM TO A GEMFILE INSTEAD OF THE GEMSPEC:
# * It needs require: false
#   * must also be in the gemspec
#   * version requirement belongs in gemspec ONLY, not in both places
# * It needs a platform restriction
#   * can't be in the gemspec
#   * version requirement belongs here only.
# * The version restrictions change between the rails-specific
#     gemfiles in the testing matrix (should also be in the gemspec
#     with a generous version restriction allowing all supported versions)
# * There are no other valid reasons.

# Gems listed here that are not also in the gemspec
#   (which necessarily includes all platform restricted gems)
#   must be configured in every Gemfile in gemfiles/ for the test matrix.
#   *This* Gemfile is ignored when the gemfiles/ are used.
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# *This* Gemfile is setup to mirror gemfiles/Gemfile.rails-4.2.x as this
#   is the default Gemfile used when bundle exec rspec spec is run without modifiers.

# The only gems that change with version of Rails being tested are:
# gem "rails",                                "~> 4.2.0"
# gem "jquery-ui-rails",                      ">= 5.0"
# gem "shoulda-matchers",                     "~> 3.0",   group: :test

# The following gems do not change with version of Rails being tested.
# If they are also listed in the gemspec the version will not be specified here.
gem "rake",                                             require: false

# The next set are listed here to restrict the platform.
# Gems that need a platform restriction can never be added
#   to the .gemspec as dependencies
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
