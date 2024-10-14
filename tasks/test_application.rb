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
      Bundler.with_original_env do
        Kernel.system("yarn install") # so tailwindcss/plugin is available for test app
        Kernel.system("rake dependencies:vendor") # ensure flowbite is updated for test app
        Dir.chdir(app_dir) do
          Kernel.system("yarn add @activeadmin/activeadmin")
          Kernel.system('npm pkg set scripts.build:css="tailwindcss -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify -c tailwind-active_admin.config.js"')
          Kernel.system("yarn install")
          Kernel.system("yarn build:css")
        end
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
        --skip-ci
        --skip-decrypted-diffs
        --skip-dev-gems
        --skip-docker
        --skip-git
        --skip-hotwire
        --skip-jbuilder
        --skip-kamal
        --skip-rubocop
        --skip-solid
        --skip-system-test
        --skip-test
        --skip-thruster
        --javascript=importmap
      )

      command = ["bundle", "exec", "rails", "new", app_dir, *args].join(" ")

      env = { "BUNDLE_GEMFILE" => expanded_gemfile, "RAILS_ENV" => rails_env }

      Bundler.with_original_env do
        Kernel.system(env, command)
      end
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
      return "rails_80" if main_app?

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
