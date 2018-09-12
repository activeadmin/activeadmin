# frozen_string_literal: true

RSpec.describe "Changelog" do
  subject(:changelog) do
    path = File.join(File.dirname(__dir__), "CHANGELOG.md")
    File.read(path)
  end

  it 'has definitions for all implicit links' do
    implicit_link_names = changelog.scan(/\[([^\]]+)\]\[\]/).flatten.uniq
    implicit_link_names.each do |name|
      expect(changelog).to include("[#{name}]: https")
    end
  end
end
