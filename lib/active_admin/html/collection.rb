module ActiveAdmin
  module HTML

    # Stores a collection of Element objects
    class Collection < Array

      def to_html
        self.collect do |element|
          element.to_html
        end.join
      end
    end

  end
end
