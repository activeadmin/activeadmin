module ActiveAdmin 
  class FormViewBuilder < ::Formtastic::SemanticFormBuilder

    def initialize(*args)
      super
      @form_buffers = [""]
    end

    def inputs(*args, &block)
      content = block_given? ? with_new_form_buffer { super } : super
      @form_buffers.last << content
    end

    def input(*args)
      @form_buffers.last << super
    end

    def buttons(*args, &block)
      @form_buffers.last << super
    end

    private

    def with_new_form_buffer
      @form_buffers << ""
      return_value = yield
      @form_buffers.pop
      return_value
    end

  end
end
