module ActiveAdmin
  class Renderer

    include ::ActiveAdmin::ViewHelpers::RendererHelper
    include Arbre::Builder

    attr_accessor :view, :assigns

    # For use in html
    alias_method :helpers, :view

    def initialize(view_or_renderer)
      @view = view_or_renderer.is_a?(Renderer) ? view_or_renderer.view : view_or_renderer

      if view.respond_to?(:assigns)
        @assigns = view.assigns.each { |key, value| instance_variable_set("@#{key}", value) }
      else
        @assigns = {}
      end
    end

    def method_missing(name,*args, &block)
      if view.respond_to?(name)
        view.send(name, *args, &block)
      else
        super
      end
    end    

    def to_html(*args)
    end

    def to_s(*args)
      to_html(*args)
    end

    def haml(template)
      begin
        require 'haml' unless defined?(Haml)
      rescue LoadError
        raise LoadError, "Please install the HAML gem to use the HAML method with ActiveAdmin"
      end

      # Find the first non whitespace character in the template
      indent = template.index(/\S/)

      # Remove the indent if its greater than 0
      if indent > 0
        template = template.split("\n").collect do |line|
          line[indent..-1]
        end.join("\n")
      end

      # Render it baby
      Haml::Engine.new(template).render(self)
    end

    protected

    # Although we make a copy of all the instance variables on the way in, it
    # doesn't mean that we can set new instance variables that are stored in
    # the context of the view. This method allows you to do that. It can be useful
    # when trying to share variables with a layout.
    def set_ivar_on_view(name, value)
      view.instance_variable_set(name, value)
    end

    # Many times throughout the views we want to either call a method on an object
    # or instance_exec a proc passing in the object as the first parameter. This
    # method takes care of this functionality.
    #
    #   call_method_or_proc_on(@my_obj, :size) same as @my_obj.size
    # OR
    #   proc = Proc.new{|s| s.size }
    #   call_method_or_proc_on(@my_obj, proc)
    #
    def call_method_or_proc_on(obj, symbol_or_proc)
      case symbol_or_proc
      when Symbol, String
        obj.send(symbol_or_proc.to_sym)
      when Proc
        instance_exec(obj, &symbol_or_proc)
      end
    end
    
  end
end
