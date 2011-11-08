require 'sass/importers'

# This monkey patches the SASS filesystem importer to work with files
# that are named *.css.scss. This allows us to be compatible with both
# Rails 3.0.* and Rails 3.1
#
# This should only be loaded in Rails 3.0 apps.
class Sass::Importers::Filesystem

  # We want to ensure that all *.css.scss files are loaded as scss files
  def extensions_with_css
    extensions_without_css.merge('{css.,}scss' => :scss)
  end
  alias_method_chain :extensions, :css

end
