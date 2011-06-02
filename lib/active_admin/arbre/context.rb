module Arbre
  class Context < Arbre::HTML::Element
    def indent_level
      # A context does not increment the indent_level
      super - 1
    end

    def bytesize
      to_html.bytesize
    end
  end
end
