require 'yard'
require 'yard/rake/yardoc_task'

namespace :docs do
  YARD::Rake::YardocTask.new do |t|
    t.files = ['lib/**/*.rb']
    t.options = ['--no-output']
  end

  def jekyll_redirect_string(filename)
    <<-EOD.strip_heredoc
      ---
      redirect_from: /docs/3-index-pages/#{filename}
      ---

    EOD
  end

  def filename_from_module(mod)
    mod.name.to_s.underscore.tr('_', '-')
  end

  def write_docstrings_to(path, mods)
    mods.each do |mod|
      filename = filename_from_module(mod)

      File.open("#{path}/#{filename}.md", 'w+') do |f|
        f << jekyll_redirect_string("#{filename}.html") + mod.docstring + "\n"
      end
    end
  end

  def docs_syncronized?
    # Do not print diff and yield whether exit code was zero
    sh('git diff --quiet docs/3-index-pages') do |outcome, _|
      return if outcome

      # Output diff before raising error
      sh('git diff docs/3-index-pages')

      raise <<-MSG.strip_heredoc
        The docs/3-index-pages directory is out of sync.
        Run rake generate_cops_documentation and commit the results.
      MSG
    end
  end

  desc "Update docs in the docs folder"
  task build: :yard do
    require 'yard'
    require 'active_support/all'

    YARD::Registry.load!
    views = YARD::Registry.at("ActiveAdmin::Views")

    # Index Types
    index_types = views.children.select { |obj| obj.name.to_s =~ /^IndexAs/ }
    write_docstrings_to "docs/3-index-pages", index_types

    docs_syncronized? if ENV["CI"]
  end
end
