module ActiveAdmin
  module HTML

    class Attributes < Hash

      def to_html
        self.collect do |name, value|
          "#{name}=\"#{value}\""
        end.join(" ")
      end

    end

  end
end
