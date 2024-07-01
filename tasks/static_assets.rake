# frozen_string_literal: true

require 'fileutils'

desc 'Create static copies of all assets'
task static_assets: %w[static_assets:css static_assets:js]

namespace :static_assets do
  dest_dir = "#{__dir__}/../lib/active_admin/static_assets/assets"

  desc 'Create static copies of stylesheets'
  task :css do
    dest = "#{dest_dir}/css/active_admin.css"

    tailwind_command = [
      "#{__dir__}/../bin/tailwindcss",
      '-i', "#{__dir__}/../lib/generators/active_admin/assets/templates/active_admin.css",
      '-o', "#{dest}",
      '-c', "#{__dir__}/static_assets.tailwind.config.js",
    ]

    system(*tailwind_command, exception: true)
    system('gzip', '-f', dest, exception: true)
  end

  desc 'Create static copies of javascripts'
  task :js do
    files = Dir["#{__dir__}/../{app,vendor}/javascript/**/*.js"]
    files.any? || raise('No javascript files found')

    files.each do |file|
      relative_path = file.split(%r{(?:app|vendor)/javascript/}).last
      dest = "#{dest_dir}/js/#{relative_path}"
      FileUtils.mkdir_p(File.dirname(dest))

      FileUtils.cp(file, dest)
      system('gzip', '-f', dest, exception: true)
    end
  end
end
