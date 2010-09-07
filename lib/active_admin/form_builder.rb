module ActiveAdmin
  class FormBuilder < ::Formtastic::SemanticFormBuilder

    attr_reader :form_buffers
    
    def initialize(*args)
      @form_buffers = ["".html_safe]
      super
    end

    def inputs(*args, &block)
      # Store that we are creating inputs without a block
      @inputs_with_block = block_given? ? true : false
      content = with_new_form_buffer { super }
      form_buffers.last << content.html_safe
    end

    # The input method returns a properly formatted string for
    # its contents, so we want to skip the internal buffering
    # while building up its contents
    def input(*args)
      content = with_new_form_buffer { super }
      return content.html_safe unless @inputs_with_block
      form_buffers.last << content.html_safe
    end

    # The buttons method always needs to be wrapped in a new buffer
    def buttons(*args, &block)
      content = with_new_form_buffer{ super }
      form_buffers.last << content.html_safe
    end

    def commit_button(*args)
      content = with_new_form_buffer{ super }
      form_buffers.last << content.html_safe
    end

    def datepicker_input(method, options)
      options = options.dup
      options[:input_html] ||= {}
      options[:input_html][:class] = [options[:input_html][:class], "datepicker"].compact.join(' ')
      options[:input_html][:size] ||= "10"
      string_input(method, options)
    end

    def has_many(association, options = {}, &block)
      options = { :for => association }.merge(options)

      content = with_new_form_buffer do
        template.content_tag :div, :class => "has_many #{association}" do
          inputs options, &block

          # Capture the ADD JS
          js = with_new_form_buffer do
            inputs_for_nested_attributes  :for => [association, object.class.reflect_on_association(association).klass.new],
                                          :for_options => {
                                            :child_index => "NEW_RECORD"
                                          }, &block
          end

          js = template.escape_javascript(js)
          js = template.link_to "Add New", "#", :onclick => "$(this).before('#{js}'.replace(/NEW_RECORD/g, new Date().getTime())); return false;"

          form_buffers.last << js.html_safe
        end
      end
      form_buffers.last << content.html_safe
    end

    private

    def with_new_form_buffer
      form_buffers << "".html_safe
      return_value = yield
      form_buffers.pop
      return_value
    end
    
  end
end
