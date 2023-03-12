# frozen_string_literal: true
RSpec.describe "Gemfile sanity" do
  it "is up to date" do
    gemfile = ENV["BUNDLE_GEMFILE"] || "Gemfile"
    current_lockfile = File.read("#{gemfile}.lock")

    new_lockfile = Bundler.with_original_env do
      `bundle lock --print`
    end

    msg = "Please update #{gemfile}'s lock file with `BUNDLE_GEMFILE=#{gemfile} bundle install` and commit the result"

    expect(current_lockfile).to eq(new_lockfile), msg
  end
end
