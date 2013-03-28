module ActiveAdmin
  class FormBuilder < ::Formtastic::FormBuilder

    attr_reader :form_buffers

    def initialize(*args)
      @form_buffers = ["".html_safe]
      super
    end

    def inputs(*args, &block)
      @inputs_with_block = block_given?
      form_buffers.last << with_new_form_buffer{ super }
    end

    # If this `input` call is inside a `inputs` block, add the content
    # to the form buffer. Else, return it directly.
    def input(method, *args)
      content = with_new_form_buffer{ super }
      @inputs_with_block ? form_buffers.last << content : content
    end

    def cancel_link(url = {:action => "index"}, html_options = {}, li_attrs = {})
      li_attrs[:class] ||= "cancel"
      li_content = template.link_to I18n.t('active_admin.cancel'), url, html_options
      form_buffers.last << template.content_tag(:li, li_content, li_attrs)
    end

    def actions(*args, &block)
      form_buffers.last << with_new_form_buffer do
        block_given? ? super : super{ commit_action_with_cancel_link }
      end
    end

    def action(*args)
      form_buffers.last << with_new_form_buffer{ super }
    end

    def commit_action_with_cancel_link
      action(:submit)
      cancel_link
    end

    def has_many(association, options = {}, &block)
      options = { :for => association }.merge(options)
      options[:class] ||= ""
      options[:class] << "inputs has_many_fields"

      # Add Delete Links
      form_block = proc do |has_many_form|
        # @see https://github.com/justinfrench/formtastic/blob/2.2.1/lib/formtastic/helpers/inputs_helper.rb#L373
        contents = if block.arity == 1  # for backwards compatibility with REE & Ruby 1.8.x
          block.call(has_many_form)
        else
          index = parent_child_index(options[:parent]) if options[:parent]
          block.call(has_many_form, index)
        end

        if has_many_form.object.new_record?
          contents += template.content_tag(:li) do
            template.link_to I18n.t('active_admin.has_many_delete'), "#", :onclick => "$(this).closest('.has_many_fields').remove(); return false;", :class => "button"
          end
        end

        contents
      end

      form_buffers.last << with_new_form_buffer do
        template.content_tag :div, :class => "has_many #{association}" do
          form_buffers.last << template.content_tag(:h3, object.class.reflect_on_association(association).klass.model_name.human(:count => 1.1))
          inputs options, &form_block

          form_buffers.last << js_for_has_many(association, form_block, template)
        end
      end
    end

    def semantic_errors(*args)
      form_buffers.last << with_new_form_buffer{ super }
    end

    # These methods are deprecated and removed from Formtastic, however are
    # supported here to help with transition.
    module DeprecatedMethods

      # Formtastic has depreciated #commit_button in favor of #action(:submit)
      def commit_button(*args)
        ::ActiveSupport::Deprecation.warn("f.commit_button is deprecated in favour of f.action(:submit)")

        options = args.extract_options!
        if String === args.first
          options[:label] = args.first unless options.has_key?(:label)
        end

        action(:submit, options)
      end

      def commit_button_with_cancel_link
        # Formtastic has depreciated #buttons in favor of #actions
        ::ActiveSupport::Deprecation.warn("f.commit_button_with_cancel_link is deprecated in favour of f.commit_action_with_cancel_link")

        commit_action_with_cancel_link
      end

      # The buttons method always needs to be wrapped in a new buffer
      def buttons(*args, &block)
        # Formtastic has depreciated #buttons in favor of #actions
        ::ActiveSupport::Deprecation.warn("f.buttons is deprecated in favour of f.actions")

        actions args, &block
      end

    end
    include DeprecatedMethods

    protected

    def active_admin_input_class_name(as)
      "ActiveAdmin::Inputs::#{as.to_s.camelize}Input"
    end

    # prevent exceptions in production environment for better performance
    def input_class_with_const_defined(as)
      input_class_name = custom_input_class_name(as)

      if ::Object.const_defined?(input_class_name)
        input_class_name.constantize
      elsif ActiveAdmin::Inputs.const_defined?(input_class_name)
        active_admin_input_class_name(as).constantize
      elsif Formtastic::Inputs.const_defined?(input_class_name)
        standard_input_class_name(as).constantize
      else
        raise Formtastic::UnknownInputError
      end
    end

    # use auto-loading in development environment
    def input_class_by_trying(as)
      begin
        begin
          custom_input_class_name(as).constantize
        rescue NameError
          begin
            active_admin_input_class_name(as).constantize
          rescue NameError
            standard_input_class_name(as).constantize
          end
        end
      end
    rescue NameError
      raise Formtastic::UnknownInputError
    end

    # This method calls the block it's passed (in our case, the `f.inputs` block)
    # and wraps the resulting HTML in a fieldset. If your block happens to return
    # nil (but it otherwise built the form correctly), the below override passes
    # the most recent part of the Active Admin form buffer.
    def field_set_and_list_wrapping(*args, &block)
      block_given? ? super{ yield || form_buffers.last } : super
    end

    private

    def with_new_form_buffer
      form_buffers << ''.html_safe
      return_value = (yield || '').html_safe
      form_buffers.pop
      return_value
    end

    # Capture the ADD JS
    def js_for_has_many(association, form_block, template)
      assoc_reflection = object.class.reflect_on_association(association)
      assoc_name       = assoc_reflection.klass.model_name
      placeholder      = "NEW_#{assoc_name.upcase.split(' ').join('_')}_RECORD"
      opts = {
        :for         => [association, assoc_reflection.klass.new],
        :class       => "inputs has_many_fields",
        :for_options => { :child_index => placeholder }
      }
      js = with_new_form_buffer{ inputs_for_nested_attributes opts, &form_block }
      js = template.escape_javascript js

      onclick = "$(this).before('#{js}'.replace(/#{placeholder}/g, new Date().getTime())); return false;"
      text    = I18n.t 'active_admin.has_many_new', :model => assoc_name.human

      template.link_to(text, "#", :onclick => onclick, :class => "button").html_safe
    end

  end
end
