module ActiveAdmin
  module Views

    class Popover < ActiveAdmin::Component
      builder_method :popover

      def build(options = {}, &block)
        options           = options.dup
        contents_root_tag = options.delete(:contents_root_tag) || :div
        options[:style]   = "display: none"

        super(options)

        @contents_root = send(contents_root_tag, :class => "popover_contents")
      end

      def add_child(child)
        if @contents_root
          @contents_root << child
        else
          super
        end
      end

    end
  end
end
