require 'active_admin/arbre/html/element'

module Arbre
  class Context < Arbre::HTML::Element
    def indent_level
      # A context does not increment the indent_level
      super - 1
    end

    def length
      to_html.length
    end
    alias :bytesize :length

    def method_missing(sym, *args, &block)
      to_html.send sym, *args, &block
    end

  end
end
