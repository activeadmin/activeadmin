module ActiveAdmin
  module Views
    # Build a Popover
    class Popover < ActiveAdmin::Component
      builder_method :popover
      
      def default_class_name
        'popover hidden'
      end
      
      def build(*args, &block)
        
        options = args.extract_options!
        
        super(options)
 
        self.id = options[:id]
        
        @contents = div(:class => "popover_contents")
        
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