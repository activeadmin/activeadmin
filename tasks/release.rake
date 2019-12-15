require "chandler/tasks"

root    = File.expand_path("..", __dir__)
version = File.read("#{root}/VERSION").strip

# See https://github.com/rails/rails/blob/master/tasks/release.rb#L26
npm_version = version.gsub(/\./).with_index { |s, i| i >= 2 ? "-" : s }

namespace :activeadmin do
  desc 'Update and synchronize versions between gem and npm package'
  task :update_versions do
    version_file    = File.join(root, 'lib', 'active_admin', 'version.rb')
    version_content = File.read(version_file)

    version_content.gsub!(/^(\s*)VERSION(\s*)= .*?$/, "\\1VERSION = '#{version}'")
    raise "Could not insert VERSION in #{version_file}" unless $1

    File.open(version_file, "w") { |f| f.write version_content }

    require "json"
    if JSON.parse(File.read("#{root}/package.json"))["version"] != npm_version
      if sh "which npm"
        sh "npm version #{npm_version} --no-git-tag-version"
      else
        raise "You must have npm installed to release ActiveAdmin."
      end
    end
  end

  desc 'Publish npm package'
  task :npm_push do
    npm_tag = /[a-z]/.match?(version) ? "pre" : "latest"
    sh "npm publish --tag #{npm_tag}"
  end
end

task "build" => "activeadmin:update_versions"

#
# Add chandler as a prerequisite for `rake release`
#
task "release:rubygem_push" => ["chandler:push", "activeadmin:npm_push"]
