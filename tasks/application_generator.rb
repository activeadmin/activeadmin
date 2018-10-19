module ActiveAdmin
  class ApplicationGenerator
    attr_reader :rails_env, :template, :parallel

    def initialize(opts = {})
      @rails_env = opts[:rails_env] || 'test'
      @template = opts[:template] || 'rails_template'
      @parallel = opts[:parallel]
    end

    def generate
      require 'rails/version'

      base_dir = rails_env == 'test' ? 'spec/rails' : '.test-rails-apps'
      app_dir = "#{base_dir}/rails-#{Rails::VERSION::STRING}"

      unless !parallel || parallel_tests_setup?
        puts "parallel_tests is not set up. (Re)building spec/rails/rails-#{Rails::VERSION::STRING} App. Please wait."
        require 'rails/version'
        system("rm -Rf spec/rails/rails-#{Rails::VERSION::STRING}")
      end

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
          --skip-coffee
        )

        command = ['bundle', 'exec', 'rails', 'new', app_dir, *args].join(' ')

        env = { 'BUNDLE_GEMFILE' => ENV['BUNDLE_GEMFILE'], 'RAILS_ENV' => rails_env }
        env['INSTALL_PARALLEL'] = 'yes' if parallel

        Bundler.with_original_env { Kernel.exec(env, command) }

        Rake::Task['parallel:after_setup_hook'].invoke if parallel
      end
    end

    private

    def parallel_tests_setup?
      require 'rails/version'
      database_config = File.join "spec", "rails", "rails-#{Rails::VERSION::STRING}", "config", "database.yml"
      File.exist?(database_config) && File.read(database_config).include?("TEST_ENV_NUMBER")
    end
  end
end
