# frozen_string_literal: true
require "fileutils"

module ActiveAdmin
  class TestApplication
    attr_reader :rails_env, :template

    def initialize(opts = {})
      @rails_env = opts[:rails_env] || "test"
      @template = opts[:template] || "rails_template"
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
        --skip-action-cable
        --skip-action-mailbox
        --skip-action-text
        --skip-active-storage
        --skip-bootsnap
        --skip-brakeman
        --skip-bundle
        --skip-bundler-audit
        --skip-ci
        --skip-coffee
        --skip-decrypted-diffs
        --skip-dev-gems
        --skip-docker
        --skip-gemfile
        --skip-git
        --skip-hotwire
        --skip-javascript
        --skip-jbuilder
        --skip-kamal
        --skip-listen
        --skip-rubocop
        --skip-solid
        --skip-spring
        --skip-system-test
        --skip-test
        --skip-test-unit
        --skip-thruster
        --skip-turbolinks
        --skip-webpack-install
      )

      command = ["bundle", "exec", "rails", "new", app_dir, *args].join(" ")

      env = { "BUNDLE_GEMFILE" => expanded_gemfile, "RAILS_ENV" => rails_env }

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
      return "rails_81" if main_app?

      File.basename(File.dirname(gemfile))
    end

    def main_app?
      expanded_gemfile == File.expand_path("Gemfile")
    end

    def gemfile
      gemfile_from_env || "Gemfile"
    end

    def gemfile_from_env
      ENV["BUNDLE_GEMFILE"]
    end
  end
end
