module Arbre
  class Context < Arbre::HTML::Element
    def indent_level
      # A context does not increment the indent_level
      super - 1
    end
  end
end
