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

  end
end
