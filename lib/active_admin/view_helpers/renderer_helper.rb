module ActiveAdmin
  module ViewHelpers
    module RendererHelper

      # Adds the ability to render ActiveAdmin::Renderers using the
      # standard render method. 
      #
      # Example:
      #
      #   render MyRendererClass, "Arg1", "Arg2"
      #
      # which is the same as doing
      #
      #   MyRendererClass.new(self).to_html("Arg1", "Arg2")
      def render(*args)
        if args[0].is_a?(Class) && args[0].ancestors.include?(ActiveAdmin::Renderer)
          renderer = args.shift
          renderer.new(self).to_html(*args)
        elsif args[0].is_a?(Class) && args[0].ancestors.include?(Arbre::HTML::Tag)
          tag_class = args.shift
          insert_tag tag_class, *args
        else
          super
        end
      end

    end
  end
end
