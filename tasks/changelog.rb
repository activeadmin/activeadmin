# frozen_string_literal: true
class Changelog
  def cut_version(header)
    sync!

    replace_with_lines([header, "", content])
  end

  def resync!
    replace_last_release_section(unreleased_changelog_content)

    add_references(last_release_section)
  end

  def sync!
    replace_unreleased_section(unreleased_changelog_content)

    add_references(unreleased_section)
  end

  private

  def unreleased_changelog_content
    lines = []

    group_by_labels(pull_requests_since_last_release).each do |label, pulls|
      category = changelog_label_mapping[label]

      lines << "### #{category}"
      lines << ""

      pulls.sort_by(&:merged_at).reverse_each do |pull|
        lines << "* #{pull.title.strip}. [##{pull.number}] by [@#{pull.user.login}]"
      end

      lines << ""
    end

    lines
  end

  def group_by_labels(pulls)
    grouped_pulls = pulls.group_by do |pull|
      relevant_label_for(pull)
    end

    grouped_pulls.delete(nil) # exclude non categorized pulls

    grouped_pulls.sort do |a, b|
      changelog_labels.index(a[0]) <=> changelog_labels.index(b[0])
    end.to_h
  end

  def pull_requests_since_last_release
    last_release_date = gh_client.releases("activeadmin/activeadmin").sort_by(&:created_at).last.created_at

    pr_ids = merged_pr_ids_since(last_release_date)

    pull_requests_for(pr_ids)
  end

  def changelog_label_mapping
    {
      "type: security fix" => "Security Fixes",
      "type: breaking change" => "Breaking Changes",
      "type: deprecation" => "Deprecations",
      "type: enhancement" => "Enhancements",
      "type: bug fix" => "Bug Fixes",
      "type: i18n" => "Translation Improvements",
      "type: documentation" => "Documentation",
      "type: dependency change" => "Dependency Changes",
      "type: performance" => "Performance",
    }
  end

  def replace_last_release_section(new_content)
    last_release_header = content[0]
    full_new_changelog = [last_release_header, "", new_content, released_section_but_last_release]

    replace_with_lines(full_new_changelog)
  end

  def replace_unreleased_section(new_content)
    full_new_changelog = [new_content, released_section]

    replace_with_lines(full_new_changelog)
  end

  def add_references(section)
    add_user_references(section)

    add_pull_request_references(section)
  end

  def relevant_label_for(pull)
    relevant_labels = pull.labels.map(&:name) & changelog_labels
    return unless relevant_labels.any?

    raise "#{pull.html_url} has multiple labels that map to changelog sections" unless relevant_labels.size == 1

    relevant_labels.first
  end

  def changelog_labels
    changelog_label_mapping.keys
  end

  def merged_pr_ids_since(date)
    commits = `git log --oneline origin/3-0-stable --since '#{date}'`.split("\n").map { |l| l.split(/\s/, 2) }
    commits.map do |_sha, message|
      match = /Merge pull request #(\d+)/.match(message)
      match ||= /\(#(\d+)\)$/.match(message)
      next unless match

      match[1].to_i
    end.compact
  end

  def pull_requests_for(ids)
    pulls = gh_client.pull_requests("activeadmin/activeadmin", sort: :updated, state: :closed, direction: :desc)

    loop do
      pulls.select! { |pull| ids.include?(pull.number) }

      return pulls if (pulls.map(&:number) & ids).to_set == ids.to_set

      pulls.concat gh_client.get(gh_client.last_response.rels[:next].href)
    end
  end

  def gh_client
    @gh_client ||= begin
      require "netrc"
      _username, token = Netrc.read["api.github.com"]

      require "octokit"
      Octokit::Client.new(access_token: token)
    end
  end

  def add_user_references(section)
    new_user_references = user_references

    section.join("\n").scan(/\[@.+\]/).each do |user|
      user_name = user[2..-2]
      new_user_references << "#{user}: https://github.com/#{user_name}"
    end

    new_unique_user_references = new_user_references.sort { |a, b| a.downcase <=> b.downcase }.uniq

    replace_with_lines([pre_user_references, new_unique_user_references])
  end

  def add_pull_request_references(section)
    new_pull_request_references = pull_request_references

    section.join("\n").scan(/\[#\d+\]/).each do |pull_request|
      pull_request_number = pull_request[2..-2]
      new_pull_request_references << "#{pull_request}: https://github.com/activeadmin/activeadmin/pull/#{pull_request_number}"
    end

    new_unique_pull_request_references = new_pull_request_references.uniq.sort

    replace_with_lines([pre_pull_request_references, new_unique_pull_request_references, post_pull_request_references])
  end

  def unreleased_section
    content.take_while { |line| !released_section_header?(line) }
  end

  def released_section
    content.drop_while { |line| !released_section_header?(line) }
  end

  def last_release_section
    released_section[1..-1].take_while { |line| !released_section_header?(line) }
  end

  def released_section_but_last_release
    released_section[1..-1].drop_while { |line| !released_section_header?(line) }
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
