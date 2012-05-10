module ActiveAdmin
  class FormBuilder < ::Formtastic::FormBuilder

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
    def input(method, *args)
      content = with_new_form_buffer { super }
      return content.html_safe unless @inputs_with_block
      form_buffers.last << content.html_safe
    end

    def cancel_link(url = nil, html_options = {}, li_attributes = {})
      li_attributes[:class] ||= "cancel"
      url ||= {:action => "index"}
      form_buffers.last << template.content_tag(:li, (template.link_to I18n.t('active_admin.cancel'), url, html_options), li_attributes)
    end

    def commit_action_with_cancel_link
      content = action(:submit)
      content << cancel_link
    end

    def actions(*args, &block)
      content = with_new_form_buffer do
        block_given? ? super : super { commit_action_with_cancel_link }
      end
      form_buffers.last << content.html_safe
    end

    def action(*args)
      content = with_new_form_buffer { super }
      form_buffers.last << content.html_safe
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
        block.call(has_many_form) + if has_many_form.object.new_record?
                                      template.content_tag :li do
                                        template.link_to I18n.t('active_admin.has_many_delete'), "#", :onclick => "$(this).closest('.has_many_fields').remove(); return false;", :class => "button"
                                      end
                                    else
                                    end
      end

      content = with_new_form_buffer do
        template.content_tag :div, :class => "has_many #{association}" do
          form_buffers.last << template.content_tag(:h3, association.to_s.titlecase)
          inputs options, &form_block

          # Capture the ADD JS
          js = with_new_form_buffer do
            inputs_for_nested_attributes  :for => [association, object.class.reflect_on_association(association).klass.new],
                                          :class => "inputs has_many_fields",
                                          :for_options => {
                                            :child_index => "NEW_RECORD"
                                          }, &form_block
          end

          js = template.escape_javascript(js)
          js = template.link_to I18n.t('active_admin.has_many_new', :model => association.to_s.singularize.titlecase), "#", :onclick => "$(this).before('#{js}'.replace(/NEW_RECORD/g, new Date().getTime())); return false;", :class => "button"

          form_buffers.last << js.html_safe
        end
      end
      form_buffers.last << content.html_safe
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

    def input_class(as)
      @input_classes_cache ||= {}
      @input_classes_cache[as] ||= begin
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
        rescue NameError
          raise Formtastic::UnknownInputError
        end
      end
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
