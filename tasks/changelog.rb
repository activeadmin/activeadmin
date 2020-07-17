class Changelog
  def cut_version(header)
    replace_with_lines([header, "", content])
  end

  def add_references
    add_user_references

    add_pull_request_references
  end

  private

  def add_user_references
    new_user_references = user_references

    unreleased_section.join("\n").scan(/\[@.+\]/).each do |user|
      user_name = user[2..-2]
      new_user_references << "#{user}: https://github.com/#{user_name}"
    end

    new_unique_user_references = new_user_references.sort { |a, b| a.downcase <=> b.downcase }.uniq

    replace_with_lines([pre_user_references, new_unique_user_references])
  end

  def add_pull_request_references
    new_pull_request_references = pull_request_references

    unreleased_section.join("\n").scan(/\[#\d+\]/).each do |pull_request|
      pull_request_number = pull_request[2..-2]
      new_pull_request_references << "#{pull_request}: https://github.com/activeadmin/activeadmin/pull/#{pull_request_number}"
    end

    new_unique_pull_request_references = new_pull_request_references.uniq.sort

    replace_with_lines([pre_pull_request_references, new_unique_pull_request_references, post_pull_request_references])
  end

  def unreleased_section
    content.take_while { |line| !released_section_header?(line) }
  end

  def pre_user_references
    content.take_while { |line| !user_reference?(line) }
  end

  def user_references
    content.drop_while { |line| !user_reference?(line) }.take_while { |line| user_reference?(line) }
  end

  def pre_pull_request_references
    content.take_while { |line| !pull_request_reference?(line) }
  end

  def post_pull_request_references
    content.drop_while { |line| !pull_request_reference?(line) }.drop_while { |line| pull_request_reference?(line) }
  end

  def pull_request_references
    content.drop_while { |line| !pull_request_reference?(line) }.take_while { |line| pull_request_reference?(line) }
  end

  def released_section_header?(line)
    line.start_with?("## ")
  end

  def user_reference?(line)
    %r{^\[@(.+)\]: https://github\.com/\1$}.match?(line)
  end

  def pull_request_reference?(line)
    %r{^\[#(\d+)\]: https://github\.com/activeadmin/activeadmin/pull/\1$}.match?(line)
  end

  def replace_with_lines(new_lines)
    File.write(changelog_file, ["# Changelog", "", "## Unreleased", "", *new_lines].join("\n") + "\n")
  end

  def content
    File.read(changelog_file).split("\n")[4..-1]
  end

  def changelog_file
    "CHANGELOG.md"
  end
end
