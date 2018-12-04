require "open3"

#
# Common stuff for a linter
#
module LinterMixin
  def run
    offenses = []

    applicable_files.each do |file|
      if clean?(file)
        print "."
      else
        offenses << file
        print "F"
      end
    end

    print "\n"

    return if offenses.empty?

    raise failure_message_for(offenses)
  end

  private

  def applicable_files
    Open3.capture2("git grep -Il ''")[0].split.reject { |file| file =~ %r{vendor/} }
  end

  def failure_message_for(offenses)
    msg = "#{self.class.name} detected offenses. "

    msg += if respond_to?(:fixing_cmd)
             "Run `#{fixing_cmd(offenses)}` to fix them."
           else
             "Affected files: #{offenses.join(' ')}"
           end

    msg
  end
end

#
# Checks trailing whitespace
#
class TrailingWhitespaceLinter
  include LinterMixin

  def clean?(file)
    File.read(file, encoding: Encoding::UTF_8) !~ / +$/
  end
end

#
# Checks trailing whitespace
#
class FixmeLinter
  include LinterMixin

  def clean?(file)
    relative_path = Pathname.new(__FILE__).relative_path_from(Pathname.new(File.dirname(__dir__))).to_s

    file == relative_path || File.read(file, encoding: Encoding::UTF_8) !~ /(BUG|FIXME)/
  end
end

desc "Lints ActiveAdmin code base"
task lint: ["lint:rubocop", "lint:mdl", "lint:trailing_whitespace", "lint:fixme", "lint:rspec"]

namespace :lint do
  require "rubocop/rake_task"
  desc "Checks ruby code style with RuboCop"
  RuboCop::RakeTask.new

  desc "Checks markdown code style with Markdownlint"
  task :mdl do
    puts "Running mdl..."

    sh("mdl", "--git-recurse", ".")
  end

  desc "Check for unnecessary trailing whitespace across all repo files"
  task :trailing_whitespace do
    puts "Checking for unnecessary trailing whitespace..."

    TrailingWhitespaceLinter.new.run
  end

  desc "Check for FIXME strings that should be fixed now, not later"
  task :fixme do
    puts "Checking for FIXME strings..."

    FixmeLinter.new.run
  end

  desc "RSpec specs for linting project files"
  task :rspec do
    puts "Linting project files..."

    sh(
      { "COVERAGE" => "true" },
      "rspec",
      "spec/gemfiles_spec.lint.rb",
      "spec/changelog_spec.lint.rb",
      "spec/i18n_spec.lint.rb"
    )
  end
end
