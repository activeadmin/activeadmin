# frozen_string_literal: true
require "rails_helper"
require "open3"
require "tmpdir"

RSpec.describe "System spec configuration" do
  def run_system_example(body, js: false, after_hook: "")
    source = <<~RUBY
      require "rails_helper"

      RSpec.configure do |config|
        config.example_status_persistence_file_path = File.join(__dir__, ".rspec_failures")
      end

      RSpec.describe "Browser failure probe", type: :system, js: #{js} do
        #{after_hook}

        it "runs the browser check" do
          #{body}
        end
      end
    RUBY

    Dir.mktmpdir("activeadmin-system-probe") do |dir|
      path = File.join(dir, "probe_spec.rb")
      File.write(path, source)
      Open3.capture3(
        { "COVERAGE" => nil },
        RbConfig.ruby, "bin/rspec", path,
        chdir: File.expand_path("../../..", __dir__)
      )
    end
  end

  it "passes all three timeout values through Rails to Ferrum" do
    stdout, stderr, status = run_system_example(<<~RUBY, js: true)
      driver = Capybara.drivers.fetch(:cuprite).call(Rails.application)
      options = Ferrum::Browser::Options.new(driver.options)
      expect(options.process_timeout).to eq(30)
      expect(options.timeout).to eq(30)
      expect(options.protocol_timeout).to eq(30)
    RUBY

    expect(status).to be_success, "#{stderr}\n#{stdout}"
    expect(stdout).to include("1 example, 0 failures")
  end

  it "logs captured Chrome output and preserves the startup failure" do
    stdout, stderr, status = run_system_example(<<~RUBY)
      raise Ferrum::ProcessTimeoutError.new(30, "Chrome stderr: startup diagnostic")
    RUBY

    expect(status).not_to be_success
    expect(stdout).to include("1 example, 1 failure", "Ferrum::ProcessTimeoutError")
    expect(stderr).to include("Chrome startup output for Browser failure probe runs the browser check")
    expect(stderr).to include("Chrome stderr: startup diagnostic")
  end

  it "logs the startup output when a cleanup error is also reported" do
    stdout, stderr, status = run_system_example(
      'raise Ferrum::ProcessTimeoutError.new(30, "Chrome stderr: original startup failure")',
      after_hook: 'after { raise Ferrum::TimeoutError.new("Target.createTarget") }'
    )

    expect(status).not_to be_success
    expect(stdout).to include("1 example, 1 failure", "Ferrum::ProcessTimeoutError", "Target.createTarget")
    expect(stderr).to include("Chrome stderr: original startup failure")
  end
end
