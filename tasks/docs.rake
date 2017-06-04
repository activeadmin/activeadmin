namespace :docs do

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

  desc "Update docs in the docs folder"
  task :build do
    require 'yard'
    require 'active_support/all'

    YARD::Registry.load!
    views = YARD::Registry.at("ActiveAdmin::Views")

    # Index Types
    index_types = views.children.select{|obj| obj.name.to_s =~ /^IndexAs/ }
    write_docstrings_to "docs/3-index-pages", index_types
  end

end
