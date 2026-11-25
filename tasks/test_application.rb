# frozen_string_literal: true
require "digest"
require "fileutils"
require "shellwords"

module ActiveAdmin
  class TestApplication
    attr_reader :rails_env, :template

    def initialize(opts = {})
      @rails_env = opts[:rails_env] || "test"
      @template = opts[:template] || "rails_template"
    end

    def soft_generate(force: false)
      FileUtils.mkdir_p("tmp")
      File.open("tmp/test_application.lock", "w") do |lock|
        lock.flock(File::LOCK_EX)
        prepare_app(force)
        build_assets
      end
    end

    def full_app_dir
      File.expand_path(app_dir)
    end

    def app_dir
      @app_dir ||= "#{base_dir}/#{app_name}"
    end

    def expanded_gemfile
      File.expand_path(ENV.fetch("BUNDLE_GEMFILE", "Gemfile"))
    end

    private

    def prepare_app(force)
      stamp = File.join(app_dir, ".activeadmin-template")
      digest = generation_digest
      exists = File.exist?(app_dir)
      stale = exists && !force && (!File.file?(stamp) || File.read(stamp) != digest)

      # Rebuilding the development app would delete its data, so only warn.
      if stale && rails_env != "test"
        gemfile_env = "BUNDLE_GEMFILE=#{Shellwords.escape(expanded_gemfile)} " unless main_app?
        warn "#{app_dir} may be out of date. " \
             "Run `#{gemfile_env}bin/rake \"setup:force[#{rails_env},#{template}]\"` to replace the app and its data."
      elsif exists && (force || stale)
        FileUtils.rm_r(app_dir)
      end

      if File.directory?(app_dir)
        puts "Using existing Rails app at #{app_dir}"
      else
        generate
        File.write(stamp, digest)
      end
    end

    # Track the templates, generators, rails new options, and resolved gems.
    def generation_digest
      files = ["spec/support/rails_template.rb", "spec/support/#{template}.rb", "tasks/test_application.rb", "#{expanded_gemfile}.lock"]
      files += Dir.glob("spec/support/{templates,templates_with_data}/**/*", File::FNM_DOTMATCH)
      files += Dir.glob("lib/generators/active_admin/{assets,devise,install}/**/*", File::FNM_DOTMATCH)
      entries = files.uniq.select { |file| File.file?(file) }.map do |file|
        [file, Digest::SHA256.file(file).hexdigest].join(":")
      end
      Digest::SHA256.hexdigest([template, *entries].join("\n"))
    end

    def build_assets
      Bundler.with_original_env do
        Kernel.system("npm", "install", exception: true) # so tailwindcss/plugin is available for app
        Kernel.system("bin/rake", "dependencies:vendor", exception: true) # update Flowbite for app
        Dir.chdir(app_dir) do
          Kernel.system("npm", "install", exception: true)
          Kernel.system("npm", "pkg", "set", "scripts.build:css=npx @tailwindcss/cli -i ./app/assets/stylesheets/active_admin.css -o ./app/assets/builds/active_admin.css --minify", exception: true)
          Kernel.system("npm", "run", "build:css", exception: true)
        end
      end
    end

    def generate
      FileUtils.mkdir_p base_dir
      args = %W(
        -m
        spec/support/#{template}.rb
        --skip-action-cable
        --skip-action-mailbox
        --skip-action-text
        --skip-active-storage
        --skip-bootsnap
        --skip-brakeman
        --skip-bundler-audit
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

      env = {
        "BUNDLE_GEMFILE" => expanded_gemfile, "RAILS_ENV" => rails_env,
        "TEST_ENV_NUMBER" => nil, "DATABASE_URL" => nil, "PRIMARY_DATABASE_URL" => nil
      }

      generated = Bundler.with_original_env do
        Kernel.system(env, "bundle", "exec", "rails", "new", app_dir, *args, exception: true)
      end
    ensure
      FileUtils.rm_rf(app_dir) unless generated
    end

    def base_dir
      @base_dir ||= "tmp/#{rails_env}_apps"
    end

    def app_name
      return "rails_81" if main_app?

      File.basename(File.dirname(expanded_gemfile))
    end

    def main_app?
      expanded_gemfile == File.expand_path("Gemfile")
    end
  end
end
