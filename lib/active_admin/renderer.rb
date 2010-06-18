module ActiveAdmin
  class Renderer

    attr_accessor :view, :assigns

    def initialize(view_or_renderer)
      @view = view_or_renderer.is_a?(Renderer) ? view_or_renderer.view : view_or_renderer
      @assigns = view.assigns.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def method_missing(*args, &block)
      view.send(*args, &block)
    end    

    def to_html(*args)
    end

    def to_s(*args)
      to_html(*args)
    end
    
  end
end
