class Changelog
  def cut_version(header)
    old_content = File.read(changelog_file).split("\n")
    new_content = [old_content[0..3], header, "", old_content[4..-1]].join("\n") + "\n"

    File.write(changelog_file, new_content)
  end

  private

  def changelog_file
    "CHANGELOG.md"
  end
end
