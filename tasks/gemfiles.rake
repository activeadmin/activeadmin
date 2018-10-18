desc "Bundle all Gemfiles"
task :bundle do
  ["Gemfile", *Dir.glob("gemfiles/*.gemfile")].each do |gemfile|
    Bundler.with_original_env do
      system({ "BUNDLE_GEMFILE" => gemfile }, "bundle install")
    end
  end
end
