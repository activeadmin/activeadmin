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

    protected

    # Although we make a copy of all the instance variables on the way in, it
    # doesn't mean that we can set new instance variables that are stored in
    # the context of the view. This method allows you to do that. It can be useful
    # when trying to share variables with a layout.
    def set_ivar_on_view(name, value)
      view.instance_variable_set(name, value)
    end
    
  end
end
