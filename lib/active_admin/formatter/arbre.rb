module ActiveAdmin
  module Formatter
    class Arbre < Base
      detection do |object|
        object.is_a?(::Arbre::Element)
      end

      formater do |object|
        object.to_s
      end
    end
  end
end
