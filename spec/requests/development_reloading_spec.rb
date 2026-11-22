# frozen_string_literal: true
require "rails_helper"
require "open3"
require "tmpdir"

# Class reloading has to be enabled when Rails boots, so this spec boots a
# copy of the test app in a child process. The copy lives in a temp
# directory, so the files it edits are never seen by other parallel workers.
RSpec.describe "Development reloading" do
  around do |example|
    Dir.mktmpdir("activeadmin-reloading") do |dir|
      @app_copy = dir
      # The child creates its own database, so node_modules, log, tmp and storage are left out.
      %w(Gemfile Rakefile app config config.ru db lib public vendor).each do |entry|
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

  it "picks up new admin files and model changes without a restart, while signed in" do
    script = File.expand_path("../support/reloading_app_script.rb", __dir__)
    repo_root = File.expand_path("../..", __dir__)

    stdout, stderr, status = Open3.capture3(
      # Database URLs override database.yml. The child loads a fresh schema,
      # so it must use the copied app's database rather than an inherited URL.
      { "RAILS_ENV" => "test", "DATABASE_URL" => nil, "PRIMARY_DATABASE_URL" => nil },
      RbConfig.ruby, script, @app_copy,
      chdir: repo_root
    )

    expect(status).to be_success, "reloading script failed:\n#{stderr}\n#{stdout}"
    result_json = stdout[/^RESULTS=(.*)$/, 1]
    expect(result_json).not_to be_nil, "reloading script returned no results:\n#{stderr}\n#{stdout}"
    results = JSON.parse(result_json)

    expect(results).to include(
      "signed_in_before_registering" => true,
      "menu_before_registering" => false,
      "signed_in_after_registering" => true,
      "menu_after_registering" => true,
      "created_flash" => true,
      "blank_title_created_before_validation" => true,
      "post_titles_before_validation" => ["A", ""],
      "invalid_status" => 422,
      "validation_error" => true,
      "created_after_invalid" => false,
      "post_count_after_invalid" => 2,
      "menu_after_model_change" => true,
      "created_after_model_change" => true,
      "post_titles" => ["A", "", "After reload"]
    )
  end
end
