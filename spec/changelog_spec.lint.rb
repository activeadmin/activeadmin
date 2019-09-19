SimpleCov.command_name "lint" if ENV["COVERAGE"] == "true"

require "kramdown"

RSpec.describe "Changelog" do
  subject(:changelog) do
    File.read("CHANGELOG.md")
  end

  it 'uses the simplest style for implicit links' do
    expect(changelog).not_to match(/\[([^\]]+)\]\[\]/)
  end

  it 'has definitions for all issue/pr references' do
    implicit_link_names = changelog.scan(/\[#([0-9]+)\] /).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[##{name}]: https://github.com/activeadmin/activeadmin/pull/#{name}").or include("[##{name}]: https://github.com/activeadmin/activeadmin/issues/#{name}")
    end
  end

  it 'does not include explicit pr links' do
    explicit_link_names = changelog.scan(/\[#([0-9]+)\]\(https:\/\/github\.com\/activeadmin\/activeadmin\/pull\/\1\)/).flatten.uniq
    expect(explicit_link_names).to be_empty
  end

  it 'has definitions for users' do
    implicit_link_names = changelog.scan(/ \[@([[:alnum:]]+)\]/).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[@#{name}]: https://github.com/#{name}")
    end
  end

  it 'sorts contributors' do
    contributors = changelog.scan(/^\[@([[:alnum:]]+)\]: https:\/\/github\.com\/\1$/).flatten
    expect(contributors).to eq(contributors.sort { |a, b| a.downcase <=> b.downcase })
  end

  describe 'entry' do
    let(:lines) { changelog.each_line }

    subject(:entries) { lines.grep(/^\*/) }

    it 'does not end with a punctuation' do
      entries.each do |entry|
        expect(entry).not_to match(/\.$/)
      end
    end
  end

  describe 'warnings' do
    subject(:document) { Kramdown::Document.new(changelog) }

    specify { expect(document.warnings).to be_empty }
  end
end
