RSpec.describe "Gemfile sanity" do
  shared_examples_for "a sane gemfile" do |gemfile|
    let(:lockfile_contents) { File.read("#{gemfile}.lock") }

    it "is up to date" do
      current_lockfile = lockfile_contents

      new_lockfile = Bundler.with_original_env do
        `BUNDLE_GEMFILE=#{gemfile} bundle lock --print`
      end

      msg = "Please update #{gemfile}'s lock file with `BUNDLE_GEMFILE=#{gemfile} bundle install` and commit the result"

      expect(current_lockfile).to eq(new_lockfile), msg
    end

    it "matches what's installed on CircleCI" do
      lockfile_regexp = /\n\nBUNDLED WITH\n\s{2,}(#{Gem::Version::VERSION_PATTERN})\n/
      lockfile_version = lockfile_regexp.match(lockfile_contents)[1]

      config_contents = File.read(".circleci/config.yml")
      config_regexp = /gem install bundler -v (#{Gem::Version::VERSION_PATTERN})\n/
      config_version = config_regexp.match(config_contents)[1]

      msg = "Please update CircleCI config to install bundler #{lockfile_version}"
      expect(config_version).to eq(lockfile_version), msg
    end
  end

  it_behaves_like "a sane gemfile", "Gemfile"

  Dir.glob("gemfiles/*.gemfile").each do |gemfile|
    it_behaves_like "a sane gemfile", gemfile
  end
end
