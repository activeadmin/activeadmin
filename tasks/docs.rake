namespace :docs do

  def rdoc_to_markdown(content)
    content.gsub(/^ ?(=+) /) do |m|
      m.gsub('=', '#')
    end
  end

  def prepare_docstring(content)
    content = rdoc_to_markdown(content)
    "<!-- Please don't edit this file. It will be clobbered. -->\n\n#{content}"
  end

  def filename_from_module(mod)
    mod.name.to_s.underscore.gsub('_', '-')
  end

  def write_docstrings_to(path, mods)
    mods.each do |mod|
      File.open("#{path}/#{filename_from_module(mod)}.md", 'w+') do |f|
        f << prepare_docstring(mod.docstring)
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
