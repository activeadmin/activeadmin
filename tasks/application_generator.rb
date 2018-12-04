require 'fileutils'

module ActiveAdmin
  class ApplicationGenerator
    attr_reader :rails_env, :template

    def initialize(opts = {})
      @rails_env = opts[:rails_env] || 'test'
      @template = opts[:template] || 'rails_template'
    end

    def generate
      if File.exist? app_dir
        puts "test app #{app_dir} already exists; skipping test app generation"
      else
        FileUtils.mkdir_p base_dir
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

        Bundler.with_original_env { abort unless Kernel.system(env, command) }
      end

      app_dir
    end

    private

    def base_dir
      @base_dir ||= rails_env == 'test' ? 'spec/rails' : '.test-rails-apps'
    end

    def app_dir
      @app_dir ||= begin
                     require 'rails/version'
                     "#{base_dir}/rails-#{Rails::VERSION::STRING}"
                   end
    end
  end
end
