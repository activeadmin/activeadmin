# frozen_string_literal: true
require "open3"

namespace :release do
  desc "Publish npm package"
  task :npm_push do
    npm_version, _error, _status = Open3.capture3("npm pkg get version")
    npm_tag = npm_version.include?("-") ? "pre" : "latest"
    system "npm", "publish", "--tag", npm_tag, exception: true
  end
end

task(:release).enhance ["release:npm_push"]
