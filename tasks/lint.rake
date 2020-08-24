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
    Open3.capture2("git grep -Il ''")[0].split.reject { |file| file =~ %r{vendor/|app/assets/javascripts/active_admin/base.js} }
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
# Checks trailing blank lines
#
class TrailingBlankLinesLinter
  include LinterMixin

  def clean?(file)
    File.read(file, encoding: Encoding::UTF_8)[-2..-1] != "\n\n"
  end
end

#
# Final new line linter
#
class MissingFinalNewLineLinter
  include LinterMixin

  def clean?(file)
    File.read(file, encoding: Encoding::UTF_8)[-1] == "\n"
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

#
# Checks sass-rails directives
#
class SassRailsLinter
  include LinterMixin

  def applicable_files
    Dir["app/assets/stylesheets/**/*.scss"]
  end

  def clean?(file)
    relative_path = Pathname.new(__FILE__).relative_path_from(Pathname.new(File.dirname(__dir__))).to_s

    file == relative_path || File.read(file, encoding: Encoding::UTF_8) !~ /(asset-url|asset-path|image-url|image-path|asset-data-url)/
  end
end

desc "Lints ActiveAdmin code base"
task lint: ["lint:rubocop", "lint:mdl", "lint:eslint", "lint:gherkin", "lint:trailing_blank_lines", "lint:missing_final_new_line", "lint:trailing_whitespace", "lint:fixme", "lint:sass_rails", "lint:rspec"]

namespace :lint do
  require "rubocop/rake_task"
  desc "Checks ruby code style with RuboCop"
  RuboCop::RakeTask.new

  desc "Checks markdown code style with Markdownlint"
  task :mdl do
    puts "Running mdl..."

    sh("mdl", "--git-recurse", ".")
  end

  desc "Checks JS code style with eslint"
  task :eslint do
    puts "Linting JS code..."

    sh("bin/yarn", "install")
    sh("bin/yarn", "eslint")
  end

  desc "Checks gherkin code style"
  task :gherkin do
    puts "Linting gherkin code..."

    sh("bin/yarn", "install")
    sh("bin/yarn", "gherkin-lint")
  end

  desc "Check for unnecessary trailing blank lines across all repo files"
  task :trailing_blank_lines do
    puts "Checking for unnecessary trailing blank lines..."

    TrailingBlankLinesLinter.new.run
  end

  desc "Check for missing final new lines across all repo files"
  task :missing_final_new_line do
    puts "Checking for missing final new lines..."

    MissingFinalNewLineLinter.new.run
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

  desc "Check for sass-rails directives to ensure webpacker compatibility"
  task :sass_rails do
    puts "Checking for sass-rails directives..."

    SassRailsLinter.new.run
  end

  desc "RSpec specs for linting project files"
  task :rspec do
    puts "Linting project files..."

    sh(
      "bin/rspec",
      *Dir.glob("spec/*.lint.rb")
    )
  end
end
