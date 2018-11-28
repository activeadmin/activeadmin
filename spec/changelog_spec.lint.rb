SimpleCov.command_name "lint" if ENV["COVERAGE"] == "true"

RSpec.describe "Changelog" do
  subject(:changelog) do
    path = File.join(File.dirname(__dir__), "CHANGELOG.md")
    File.read(path)
  end

  it 'has definitions for all implicit links' do
    implicit_link_names = changelog.scan(/\[([^\\\[:]+)\][^(]/).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[#{name}]: https")
    end
  end

  it 'uses the simplest style for implicit links' do
    expect(changelog).not_to match(/\[([^\]]+)\]\[\]/)
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
end
