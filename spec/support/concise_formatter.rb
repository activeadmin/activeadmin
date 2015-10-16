# SRP: This formatter will completely ignore pending specs.
#      Good for those times when you run a massive script that runs all specs against all supported Rubies and Gemfiles.
# Usage:
#
#     bundle exec rspec spec --require spec/support/concise_formatter --format ConciseFormatter
#
class ConciseFormatter < RSpec::Core::Formatters::ProgressFormatter
  RSpec::Core::Formatters.register self, :example_pending, :dump_pending
  def example_pending(_notification); end
  def dump_pending(_notification); end
end
