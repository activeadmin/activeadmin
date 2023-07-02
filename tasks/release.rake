# frozen_string_literal: true
require "chandler/tasks"
require_relative "release_manager"

namespace :release do
  desc "Publish npm package"
  task :npm_push do
    ReleaseManager.new.npm_push
  end

  desc "Prepare a prerelease"
  task :prepare_prerelease do
    ReleaseManager.new.prepare_prerelease
  end

  desc "Prepare a prerelease for the next patch release"
  task :prepare_prepatch do
    ReleaseManager.new.prepare_prepatch
  end

  desc "Prepare a patch release"
  task :prepare_patch do
    ReleaseManager.new.prepare_patch
  end

  desc "Prepare a prerelease for the next minor release"
  task :prepare_preminor do
    ReleaseManager.new.prepare_preminor
  end

  desc "Prepare a minor release"
  task :prepare_minor do
    ReleaseManager.new.prepare_minor
  end

  desc "Prepare a prerelease for the next major release"
  task :prepare_premajor do
    ReleaseManager.new.prepare_premajor
  end

  desc "Prepare a major release"
  task :prepare_major do
    ReleaseManager.new.prepare_major
  end
end

task(:release).enhance ["release:npm_push", "chandler:push"]
