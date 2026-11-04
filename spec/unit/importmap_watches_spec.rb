# frozen_string_literal: true
require "rails_helper"

RSpec.describe "importmap_watches" do
  let(:application) { ActiveAdmin.application }

  around do |example|
    original = application.importmap_watches.dup
    example.run
  ensure
    application.importmap_watches = original
    ActiveAdmin::Engine.build_importmap_cache_sweeper
  end

  it "watches ActiveAdmin's own JavaScript by default" do
    expect(application.importmap_watches).to include(ActiveAdmin::Engine.root.join("app/javascript").to_s)
  end

  it "does not share appended directories with another application" do
    application.importmap_watches << "/plugin/app/javascript"

    expect(ActiveAdmin::Application.new.importmap_watches).not_to include("/plugin/app/javascript")
  end

  it "builds the ActiveAdmin import map sweeper during boot" do
    expect(ActiveAdmin.importmap.cache_sweeper).to be_present
  end

  it "clears the import map cache when a file in an added directory changes" do
    Dir.mktmpdir do |dir|
      application.importmap_watches += [Pathname(dir)]
      ActiveAdmin::Engine.build_importmap_cache_sweeper

      File.write(File.join(dir, "plugin.js"), "export default 1")
      FileUtils.touch(File.join(dir, "plugin.js"), mtime: Time.now + 5)

      expect(ActiveAdmin.importmap).to receive(:clear_cache)
      ActiveAdmin.importmap.cache_sweeper.execute_if_updated
    end
  end
end
