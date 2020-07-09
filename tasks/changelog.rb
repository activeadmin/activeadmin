class Changelog
  def cut_version(header)
    replace_with_lines([content[0..3], header, "", content[4..-1]])
  end

  private

  def replace_with_lines(new_lines)
    File.write(changelog_file, new_lines.join("\n") + "\n")
  end

  def content
    File.read(changelog_file).split("\n")
  end

  def changelog_file
    "CHANGELOG.md"
  end
end
