require 'set'

module Arbre
  module HTML

    # Holds a set of classes
    class ClassList < Set

      def add(class_names)
        class_names.to_s.split(" ").each do |class_name|
          super(class_name)
        end
        self
      end
      alias :<< :add

      def to_s
        to_html
      end

      def to_html
        to_a.join(" ")
      end

    end

  end
end
