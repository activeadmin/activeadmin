require 'erb'

module ActiveAdmin
  class Renderer
    module HTML

      class Tag < Element
        attr_reader :attributes

        def self.builder_method(method_name)
          ::ActiveAdmin::Renderer::HTML::BuilderMethods.class_eval <<-EOF, __FILE__, __LINE__
            def #{method_name}(*args, &block)
              insert_tag #{self.name}, *args, &block
            end
          EOF
        end

        def initialize
          super
          @attributes = Attributes.new
        end

        def tag_name
          @tag_name ||= self.class.name.demodulize.downcase
        end

        def build(*args)
          super
          attributes = args.extract_options!
          self.content = args.first if args.first

          attributes.each do |key, value|
            set_attribute(key, value)
          end
        end

        def set_attribute(name, value)
          @attributes[name.to_sym] = value
        end

        def get_attribute(name)
          @attributes[name.to_sym]
        end
        alias :attr :get_attribute

        def has_attribute?(name)
          @attributes.has_key?(name.to_sym)
        end

        def remove_attribute(name)
          @attributes.delete(name.to_sym)
        end

        def to_html
          "<#{tag_name}#{attributes_html}>#{content}</#{tag_name}>"
        end

        private

        def attributes_html
          attributes.any? ? " " + attributes.to_html : nil
        end

      end

    end
  end
end
