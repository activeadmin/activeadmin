module ActiveAdmin
  class Renderer
    module HTML

      class Tag < Element
        attr_reader :name

        def initialize(name)
          super()
          @name = name
        end

        # The first element is the content
        def build(*args)
          add_child(args.first)
        end

        def to_html
          "<#{name}>#{content}</#{name}>"
        end
      end

    end
  end
end
