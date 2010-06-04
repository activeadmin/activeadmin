require 'ostruct'

module ActiveAdmin
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    
    def initialize(*args)
      super(*args)
      @form_buffers = [""]
    end

    # Sets up buffering for this form which allows
    # the entire form to be built in a block outside
    # of the context of the view. Ie: you don't need
    # to use erb tags.
    def self.buffer_output_for(*method_names)
      method_names.each do |method_name|
        module_eval <<-EOF
          def #{method_name}(*args)
            content = block_given? ? with_new_form_buffer { super } : super
            @form_buffers.last << content
          end
        EOF
      end
    end

    buffer_output_for   :inputs,
                        :input,
                        :buttons,
                        :commit_button

    def semantic_fields_for(record_or_name_or_array, *args, &block)
      opts = args.extract_options!
      opts[:builder] ||= ::ActiveAdmin::FormBuilder
      args.push(opts)
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
