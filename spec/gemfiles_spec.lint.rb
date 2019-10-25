RSpec.describe "Gemfile sanity" do
  shared_examples_for "a sane gemfile" do |gemfile|
    it "is up to date" do
      current_lockfile = File.read("#{gemfile}.lock")

      new_lockfile = Bundler.with_original_env do
        `BUNDLE_GEMFILE=#{gemfile} bundle lock --print`
      end

      msg = "Please update #{gemfile}'s lock file with `BUNDLE_GEMFILE=#{gemfile} bundle install` and commit the result"

      expect(current_lockfile).to eq(new_lockfile), msg
    end
  end

  it_behaves_like "a sane gemfile", "Gemfile"

  Dir.glob("gemfiles/rails_*/Gemfile").each do |gemfile|
    it_behaves_like "a sane gemfile", gemfile
  end
end
