require 'bundler/gem_tasks'

desc 'Creates a test rails app for the specs to run against'
task :setup, [:parallel, :rails_env, :template] do |_t, opts|
  require 'rails/version'

  rails_env = opts[:rails_env] || 'test'

  base_dir = rails_env == 'test' ? 'spec/rails' : '.test-rails-apps'
  app_dir = "#{base_dir}/rails-#{Rails::VERSION::STRING}"
  template = opts[:template] || 'rails_template'

  if File.exist? app_dir
    puts "test app #{app_dir} already exists; skipping"
  else
    system "mkdir -p #{base_dir}"
    args = %W(
      -m spec/support/#{template}.rb
      --skip-bootsnap
      --skip-bundle
      --skip-gemfile
      --skip-listen
      --skip-turbolinks
      --skip-test-unit
    )

    command = ['bundle', 'exec', 'rails', 'new', app_dir, *args].join(' ')

    env = { 'BUNDLE_GEMFILE' => ENV['BUNDLE_GEMFILE'], 'RAILS_ENV' => rails_env }
    env['INSTALL_PARALLEL'] = 'yes' if opts[:parallel]

    Bundler.with_original_env { Kernel.exec(env, command) }

    Rake::Task['parallel:after_setup_hook'].invoke if opts[:parallel]
  end
end

# Import all our rake tasks
FileList['tasks/**/*.rake'].each { |task| import task }

task default: :test

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort 'Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine'
  end
end

task :console do
  require 'irb'
  require 'irb/completion'

  ARGV.clear
  IRB.start
end
