# frozen_string_literal: true
SimpleCov.command_name "lint" if ENV["COVERAGE"] == "true"

require "kramdown"

RSpec.describe "Changelog" do
  subject(:changelog) do
    File.read("CHANGELOG.md")
  end

  it "uses the simplest style for implicit links" do
    expect(changelog).not_to match(/\[([^\]]+)\]\[\]/)
  end

  it "has definitions for all issue/pr references" do
    implicit_link_names = changelog.scan(/\[#(\d+)\] /).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[##{name}]: https://github.com/activeadmin/activeadmin/pull/#{name}").or include("[##{name}]: https://github.com/activeadmin/activeadmin/issues/#{name}")
    end
  end

  it "does not include explicit pr links" do
    explicit_link_names = changelog.scan(/\[#(\d+)\]\(https:\/\/github\.com\/activeadmin\/activeadmin\/pull\/\1\)/).flatten.uniq
    expect(explicit_link_names).to be_empty
  end

  it "has definitions for users" do
    implicit_link_names = changelog.scan(/\[@([^\]]+)\]/).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[@#{name}]: https://github.com/#{name}")
    end
  end

  it "sorts contributors" do
    contributors = changelog.scan(/^\[@([^\]]+)\]: https:\/\/github\.com\/\1$/).flatten
    expect(contributors).to eq(contributors.sort { |a, b| a.downcase <=> b.downcase })
  end

  it "sorts pull requests" do
    pull_requests = changelog.scan(/^\[#(\d+)\]\: https:\/\/github\.com\/activeadmin\/activeadmin\/pull\/\1$/).flatten
    expect(pull_requests).to eq(pull_requests.sort)
  end

  it "has well defined third level entries" do
    third_level_entries = changelog.scan(/^### (.*)$/).flatten.uniq.sort
    expect(third_level_entries).to eq(["Breaking Changes", "Bug Fixes", "Dependency Changes", "Deprecations", "Documentation", "Enhancements", "Performance", "Security Fixes", "Translation Improvements"])
  end

  describe "entry" do
    let(:lines) { changelog.each_line }

    subject(:entries) { lines.grep(/^\*/) }

    it "does not end with a punctuation" do
      entries.each do |entry|
        expect(entry).not_to match(/\.$/)
      end
    end
  end

  describe "warnings" do
    subject(:document) { Kramdown::Document.new(changelog) }

    specify { expect(document.warnings).to be_empty }
  end
end
