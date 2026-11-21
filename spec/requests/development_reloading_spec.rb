# frozen_string_literal: true
require "rails_helper"
require "open3"
require "tmpdir"

# Class reloading has to be enabled when Rails boots, so this spec boots a
# copy of the test app in a child process. The copy lives in a temp
# directory, so the files it edits are never seen by other parallel workers.
RSpec.describe "Development reloading" do
  # Everything the app needs at runtime. node_modules, log, tmp and storage
  # are left out: the child creates its own database.
  APP_ENTRIES = %w(Gemfile Rakefile app config config.ru db lib public vendor).freeze

  around do |example|
    Dir.mktmpdir("activeadmin-reloading") do |dir|
      @app_copy = dir
      APP_ENTRIES.each do |entry|
        source = Rails.root.join(entry)
        FileUtils.cp_r(source, dir) if source.exist?
      end
      FileUtils.mkdir_p(File.join(dir, "storage"))

      # Rails detects changes by comparing modification times. Backdating the
      # copy guarantees the script's edits look newer even on filesystems with
      # one-second timestamps.
      past = Time.now - 60
      Dir.glob("#{dir}/**/*").each { |path| File.utime(past, past, path) }

      example.run
    end
  end

  it "picks up new admin files and model changes without a restart" do
    script = File.expand_path("../support/reloading_app_script.rb", __dir__)
    repo_root = File.expand_path("../..", __dir__)

    stdout, stderr, status = Open3.capture3(
      { "RAILS_ENV" => "test" },
      RbConfig.ruby, script, @app_copy,
      chdir: repo_root
    )

    expect(status).to be_success, "reloading script failed:\n#{stderr}\n#{stdout}"
    results = JSON.parse(stdout[/^RESULTS=(.*)$/, 1])

    expect(results).to include(
      "menu_before_registering" => false,
      "menu_after_registering" => true,
      "create_status" => 303,
      "created_flash" => true,
      "invalid_status" => 422,
      "validation_error" => true
    )
  end
end
