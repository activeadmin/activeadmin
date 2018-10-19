desc 'Runs a command agains the local sample application'
task :local do
  Rake::Task['setup'].invoke(false,
                             '.test-rails-apps',
                             'rails_template_with_data')

  app_folder = ".test-rails-apps/rails-#{Rails::VERSION::STRING}"

  # Discard the "local" argument (name of the task)
  argv = ARGV[1..-1]

  # If it's a rails command, or we're using Rails 5, auto add the rails script
  rails_commands = %w(generate console server db dbconsole g c s runner)

  if rails_commands.include?(argv[0])
    argv.unshift('rails')
  end

  command = ['bundle', 'exec', *argv].join(' ')
  gemfile = ENV['BUNDLE_GEMFILE'] || File.expand_path("../Gemfile", __dir__)
  env = { 'BUNDLE_GEMFILE' => gemfile }

  Dir.chdir(app_folder) do
    Bundler.with_original_env { Kernel.exec(env, command) }
  end
end
