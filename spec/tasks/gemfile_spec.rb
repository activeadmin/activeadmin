# frozen_string_literal: true
RSpec.describe "Gemfile sanity" do
  # Strips the BUNDLED WITH section from a Gemfile.lock content string.
  # This section only contains the Bundler version used and can differ between environments
  # without affecting the actual dependency resolution.
  #
  # Handles various edge cases:
  # - Different line endings (\n, \r\n)
  # - Any amount of whitespace before the version number
  # - Missing BUNDLED WITH section
  # - Different formatting
  def strip_bundled_with(lockfile_content)
    # Normalize line endings to Unix style for consistent comparison
    normalized = lockfile_content.gsub(/\r\n/, "\n")

    # Remove the BUNDLED WITH section and everything after it
    # The regex matches:
    # - Optional newline before BUNDLED WITH
    # - The BUNDLED WITH line itself
    # - Any content after it (version number with any whitespace/line endings)
    normalized.gsub(/\n?BUNDLED WITH\n.*\z/m, '').strip
  end

  it "is up to date" do
    gemfile = ENV["BUNDLE_GEMFILE"] || "Gemfile"
    current_lockfile = File.read("#{gemfile}.lock")

    new_lockfile = Bundler.with_original_env do
      `bundle lock --print`
    end

    msg = "Please update #{gemfile}'s lock file with `BUNDLE_GEMFILE=#{gemfile} bundle install --all` and commit the result"

    # Compare lockfiles without the BUNDLED WITH section to avoid false failures
    # when only the Bundler version differs between environments
    expect(strip_bundled_with(current_lockfile)).to eq(strip_bundled_with(new_lockfile)), msg
  end
end
