module ActiveAdmin
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    
    def initialize(*args)
      @form_buffers = ["".html_safe]
      @skip_form_buffer = false
      super
    end

    # Sets up buffering for this form which allows
    # the entire form to be built in a block outside
    # of the context of the view. Ie: you don't need
    # to use erb tags.
    def self.buffer_output_for(*method_names)
      method_names.each do |method_name|
        module_eval <<-EOF
          def #{method_name}(*args)
            content = block_given? ? with_new_form_buffer{ super } : super
            return content if @skip_form_buffer
            @form_buffers.last << content.html_safe
          end
        EOF
      end
    end

    buffer_output_for   :inputs,
                        :submit,
                        :label,
                        :inputs_for_nested_attributes,
                        :semantic_fields_for,
                        :text_field,
                        :text_area,
                        :datetime_select,
                        :time_select,
                        :date_select,
                        :radio_button,
                        :file_field,
                        :hidden_field

    # The input method returns a properly formatted string for
    # its contents, so we want to skip the internal buffering
    # while building up its contents
    def input(*args)
      @skip_form_buffer = true
      content = super
      @skip_form_buffer = false
      @form_buffers.last << content.html_safe
    end

    # The buttons method always needs to be wrapped in a new buffer
    def buttons(*args, &block)
      content = with_new_form_buffer{ super }
      @form_buffers.last << content.html_safe
    end

    private

    def with_new_form_buffer
      @form_buffers << "".html_safe
      return_value = yield
      @form_buffers.pop
      return_value
    end

    def skip_form_buffers
      @skip_form_buffer = true
      return_value = yield
      @skip_form_buffer = false
      return_value
    end
    
  end
end
