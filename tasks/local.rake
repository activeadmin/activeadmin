# frozen_string_literal: true
desc "Run a command against the local sample application"
task :local do
  require_relative "test_application"

  test_application = ActiveAdmin::TestApplication.new(
    rails_env: "development",
    template: "rails_template_with_data"
  )

  test_application.soft_generate

  # Discard the "local" argument (name of the task)
  argv = ARGV[1..-1]

  if argv.any?
    if %w(server s).include?(argv[0])
      command = "foreman start -f Procfile.dev"
    # If it's a rails command, auto add the rails script
    elsif %w(generate console dbconsole g c routes runner).include?(argv[0]) || argv[0].include?('db:')
      argv.unshift("rails")
      command = ["bundle", "exec", *argv].join(" ")
    end

    env = { "BUNDLE_GEMFILE" => test_application.expanded_gemfile, "RAILS_ENV" => "development" }

    Dir.chdir(test_application.app_dir) do
      Bundler.with_original_env { Kernel.exec(env, command) }
    end
  end
end
