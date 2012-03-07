module ActiveAdmin
  module Views
    # Build a Popover
    class Popover < ActiveAdmin::Component
      builder_method :popover
      
      def default_class_name
        'popover'
      end
      
      def build(*args, &block)
        
        options = args.extract_options!
        
        self.id = options[:id]
        
        super(options)
        
        @contents ||= div(:class => "popover_contents")
        
        # Hide the popover by default
        
        attributes[:style] = "display: none"
      end
      
      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end
      
    end
  end
end