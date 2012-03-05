module Arbre
  module HTML

    class Attributes < Hash

      def to_s
        self.collect do |name, value|
          "#{html_escape(name)}=\"#{html_escape(value)}\""
        end.join(" ")
      end

      protected

      def html_escape(s)
        ERB::Util.html_escape(s)
      end
    end

  end
end
