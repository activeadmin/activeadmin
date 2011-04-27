module Arbre
  module HTML

    # Stores a collection of Element objects
    class Collection < Array

      def +(other)
        self.class.new(super)
      end

      def -(other)
        self.class.new(super)
      end

      def &(other)
        self.class.new(super)
      end

      def to_html
        self.collect do |element|
          element.to_html
        end.join.html_safe
      end
    end

  end
end
