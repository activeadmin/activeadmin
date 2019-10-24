desc "Bundle all Gemfiles"
task :bundle do |_t, opts|
  ["Gemfile", *Dir.glob("gemfiles/rails_*/Gemfile")].each do |gemfile|
    Bundler.with_original_env do
      sh({ "BUNDLE_GEMFILE" => gemfile }, "bundle", *opts)
    end
  end
end
