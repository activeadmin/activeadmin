require_relative "changelog"

class ReleaseManager
  def initialize
    assert_compatible_ruby!
    assert_synced_versioning!
    assert_clean_state!
  end

  def npm_push
    npm_tag = npm_version.include?("-") ? "pre" : "latest"

    system "npm", "publish", "--tag", npm_tag, exception: true
  end

  def prepare_prerelease
    raise "Current release is not a prerelease. Use #prepare_prepatch, #prepare_preminor, or #prepare_premajor to start a new prerelease series" unless prerelease?(gem_version)

    new_gem_prerelease = bump_gem_pre_version(:prerelease)

    prepare_version(new_gem_prerelease)
  end

  def prepare_prepatch
    new_gem_patch = bump_gem_version(:patch)

    prepare_version(first_pre_for(new_gem_patch))
  end

  def prepare_patch
    new_gem_patch = bump_gem_version(:patch)

    prepare_version(new_gem_patch)
  end

  def prepare_preminor
    new_gem_minor = bump_gem_version(:minor)

    prepare_version(first_pre_for(new_gem_minor))
  end

  def prepare_minor
    new_gem_minor = bump_gem_version(:minor)

    prepare_version(new_gem_minor)
  end

  def prepare_premajor
    new_gem_major = bump_gem_version(:major)

    prepare_version(first_pre_for(new_gem_major))
  end

  def prepare_major
    new_gem_major = bump_gem_version(:major)

    prepare_version(new_gem_major)
  end

  private

  def assert_compatible_ruby!
    incompatible_ruby = Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.7.0")

    raise "Unsupported ruby version. Use ruby 2.7.0 or higher to release" if incompatible_ruby
  end

  def assert_synced_versioning!
    unsynced_versioning = npmify(gem_version) != npm_version

    raise "Incompatible versions (gem: #{gem_version}, npm: #{npm_version})" if unsynced_versioning
  end

  def assert_clean_state!
    clean_state = system("git", "diff", "--exit-code", *involved_files)

    raise "Source control changes present in one of #{involved_files}. Commit or discard these first" unless clean_state
  end

  def npmify(version)
    # See https://github.com/rails/rails/blob/0d0c30e534af7f80ec8b18eb946aaa613ca30444/tasks/release.rb#L26
    version.gsub(/\./).with_index { |s, i| i == 2 ? "-" : s }
  end

  def bump_gem_pre_version
    phase = :looking_for_prerelease_part

    gem_version_segments.map do |segment|
      if segment =~ /[a-z]/
        phase = :bumping_pre_release
        segment
      else
        if phase == :bumping_pre_release
          phase = :done
          segment + 1
        else
          segment
        end
      end
    end.join(".")
  end

  def bump_gem_version(level)
    gem_version_segments.map.with_index do |segment, index|
      index_level = level_to_index(level)

      if index < index_level
        segment
      elsif index == index_level
        segment + 1
      else
        0
      end
    end.join(".")
  end

  def first_pre_for(version)
    "#{version}.pre.1"
  end

  def level_to_index(level)
    if level == :patch
      2
    elsif level == :minor
      1
    elsif level == :major
      0
    end
  end

  def prepare_version(version)
    create_release_branch(version)

    bump_gem(version)
    bump_npm(version)

    cut_changelog(version)
    commit(version)
  rescue
    revert_changes
    raise
  end

  def revert_changes
    system "git", "checkout", "--", *involved_files, exception: true
  end

  def bump_npm(version)
    system "npm", "version", npmify(version), "--no-git-tag-version", exception: true
  end

  def create_release_branch(version)
    system "git", "checkout", "-b", "release/#{version}", exception: true
  end

  def bump_gem(version)
    bump_version_file(version)
    bump_lockfiles(version)
  end

  def bump_version_file(version)
    old_content = File.read(gem_version_file)
    new_content = old_content.gsub!(/^  VERSION = ".*"$/, "  VERSION = \"#{version}\"")

    File.open(gem_version_file, "w") { |f| f.puts new_content }
  end

  def bump_lockfiles(version)
    lockfiles.each do |lockfile|
      old_content = File.read(lockfile)
      new_content = old_content.gsub!(/^    activeadmin \(.*\)$/, "    activeadmin (#{version})")

      File.open(lockfile, "w") { |f| f.puts new_content }
    end
  end

  def involved_files
    [gem_version_file, *lockfiles, npm_version_file, changelog_file]
  end

  def lockfiles
    ["Gemfile.lock", *Dir.glob("gemfiles/rails_*/Gemfile.lock")]
  end

  def cut_changelog(version)
    header = "## #{version} [☰](https://github.com/activeadmin/activeadmin/compare/v#{gem_version}..v#{version})"

    Changelog.new.cut_version(header)
  end

  def commit(version)
    system "git", "commit", "-am", "Get ready for #{version} release", exception: true
  end

  def gem_version_file
    "lib/active_admin/version.rb"
  end

  def npm_version_file
    "package.json"
  end

  def changelog_file
    "CHANGELOG.md"
  end

  def npm_version
    @npm_version ||=
      begin
        require "json"
        JSON.parse(File.read(npm_version_file))["version"]
      end
  end

  def gem_version
    @gem_version ||= File.read(gem_version_file).match(/^  VERSION = "(.*)"$/)[1]
  end

  def prerelease?(version)
    version.match?(/[a-z]/)
  end

  def gem_version_segments
    @gem_version_segments ||= Gem::Version.new(gem_version).segments
  end
end
