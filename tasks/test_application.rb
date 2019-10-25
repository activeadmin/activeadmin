require 'fileutils'

module ActiveAdmin
  class TestApplication
    attr_reader :rails_env, :template

    def initialize(opts = {})
      @rails_env = opts[:rails_env] || 'test'
      @template = opts[:template] || 'rails_template'
    end

    def soft_generate
      if File.exist? app_dir
        puts "test app #{app_dir} already exists; skipping test app generation"
      else
        generate
      end
    end

    def generate
      FileUtils.mkdir_p base_dir
      args = %W(
        -m spec/support/#{template}.rb
        --skip-bootsnap
        --skip-bundle
        --skip-gemfile
        --skip-listen
        --skip-spring
        --skip-turbolinks
        --skip-test-unit
        --skip-coffee
        --skip-webpack-install
      )

      args << "--skip-turbolinks" unless turbolinks_app?

      command = ['bundle', 'exec', 'rails', 'new', app_dir, *args].join(' ')

      env = { 'BUNDLE_GEMFILE' => expanded_gemfile, 'RAILS_ENV' => rails_env }

      Bundler.with_original_env { abort unless Kernel.system(env, command) }
    end

    def full_app_dir
      File.expand_path(app_dir)
    end

    def app_dir
      @app_dir ||= "#{base_dir}/#{app_name}"
    end

    def expanded_gemfile
      return gemfile if Pathname.new(gemfile).absolute?

      File.expand_path(gemfile)
    end

    private

    def base_dir
      @base_dir ||= "tmp/#{rails_env}_apps"
    end

    def app_name
      return "rails_60" if main_app?

      File.basename(File.dirname(gemfile))
    end

    def main_app?
      expanded_gemfile == File.expand_path('Gemfile')
    end

    def turbolinks_app?
      expanded_gemfile == File.expand_path('gemfiles/rails_60_turbolinks/Gemfile')
    end

    def gemfile
      gemfile_from_env || "Gemfile"
    end

    def gemfile_from_env
      ENV["BUNDLE_GEMFILE"]
    end
  end
end
