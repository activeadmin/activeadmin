# Provides an intuitive way to build has_many associated records in the same form.
module Formtastic
  module Inputs
    module Base
      def input_wrapping(&block)
        html = super
        template.concat(html) if template.output_buffer && template.assigns[:has_many_block]
        html
      end
    end
  end
end

module ActiveAdmin
  class FormBuilder < ::Formtastic::FormBuilder

    self.input_namespaces = [::Object, ::ActiveAdmin::Inputs, ::Formtastic::Inputs]

    # TODO: remove both class finders after formtastic 4 (where it will be default)
    self.input_class_finder = ::Formtastic::InputClassFinder
    self.action_class_finder = ::Formtastic::ActionClassFinder

    def cancel_link(url = {action: "index"}, html_options = {}, li_attrs = {})
      li_attrs[:class] ||= "cancel"
      li_content = template.link_to I18n.t('active_admin.cancel'), url, html_options
      template.content_tag(:li, li_content, li_attrs)
    end

    attr_accessor :already_in_an_inputs_block

    def assoc_heading(assoc)
      object.class.reflect_on_association(assoc).klass.model_name.
        human(count: ::ActiveAdmin::Helpers::I18n::PLURAL_MANY_COUNT)
    end

    def has_many(assoc, options = {}, &block)
      builder_options, options = partition_custom_settings(options)
      builder_options.reverse_merge!(new_record: true)
      options.reverse_merge!(for: assoc)
      options[:class] = [options[:class], "inputs has_many_fields"].compact.join(' ')
      sortable_column = builder_options[:sortable]
      sortable_start  = builder_options.fetch(:sortable_start, 0)

      if sortable_column
        options[:for] = [assoc, sorted_children(assoc, sortable_column)]
      end

      html = "".html_safe
      unless builder_options.key?(:heading) && !builder_options[:heading]
        html << template.content_tag(:h3) do
          builder_options[:heading] || assoc_heading(assoc)
        end
      end

      html << template.capture do
        content_has_many(assoc, options, builder_options, &block)
      end

      tag = @already_in_an_inputs_block ? :li : :div
      html = template.content_tag(tag, html, class: "has_many_container #{assoc}", 'data-sortable' => sortable_column, 'data-sortable-start' => sortable_start)
      template.concat(html) if template.output_buffer
      html
    end

    protected

    # remove options that should not render as attributes
    def partition_custom_settings(options)
      custom_settings = %i(new_record allow_destroy heading sortable sortable_start)
      options.partition { |k, v| custom_settings.include?(k) }.map(&:to_h)
    end

    def content_has_many(assoc, options, builder_options, &block)
      form_block = proc do |has_many_form|
        render_has_many_form(has_many_form, options[:parent], builder_options, &block)
      end

      template.assigns[:has_many_block] = true
      contents = without_wrapper { inputs(options, &form_block) }
      contents ||= "".html_safe

      new_record = builder_options[:new_record]
      js = new_record ? js_for_has_many(assoc, new_record, options[:class], &form_block) : ''
      contents << js
    end

    # Renders the Formtastic inputs then appends ActiveAdmin delete and sort actions.
    def render_has_many_form(has_many_form, parent, builder_options, &block)
      index = parent && parent_child_index(parent)
      template.concat template.capture { has_many_form.instance_exec(has_many_form, index, &block) }
      template.concat has_many_actions(has_many_form, builder_options, "".html_safe)
    end

    def has_many_actions(has_many_form, builder_options, contents)
      if has_many_form.object.new_record?
        contents << template.content_tag(:li) do
          template.link_to I18n.t('active_admin.has_many_remove'), "#", class: 'button has_many_remove'
        end
      elsif allow_destroy?(has_many_form.object, builder_options[:allow_destroy])
        has_many_form.input(:_destroy, as: :boolean,
                            wrapper_html: {class: 'has_many_delete'},
                            label: I18n.t('active_admin.has_many_delete'))
      end

      if builder_options[:sortable]
        has_many_form.input builder_options[:sortable], as: :hidden

        contents << template.content_tag(:li, class: 'handle') do
          I18n.t('active_admin.move')
        end
      end

      contents
    end

    def allow_destroy?(form_object, destroy_option)
      !! case destroy_option
         when Symbol, String
           form_object.public_send destroy_option
         when Proc
           destroy_option.call form_object
         else
           destroy_option
         end
    end

    def sorted_children(assoc, column)
      object.public_send(assoc).sort_by do |o|
        attribute = o.public_send column
        [attribute.nil? ? Float::INFINITY : attribute, o.id || Float::INFINITY]
      end
    end

    private

    def without_wrapper
      is_being_wrapped = @already_in_an_inputs_block
      @already_in_an_inputs_block = false

      html = yield

      @already_in_an_inputs_block = is_being_wrapped
      html
    end

    # Capture the ADD JS
    def js_for_has_many(assoc, new_record, class_string, &form_block)
      assoc_reflection = object.class.reflect_on_association assoc
      assoc_name       = assoc_reflection.klass.model_name
      placeholder      = "NEW_#{assoc_name.to_s.underscore.upcase.gsub(/\//, '_')}_RECORD"
      opts = {
        for: [assoc, assoc_reflection.klass.new],
        class: class_string,
        for_options: { child_index: placeholder }
      }
      html = template.capture{ inputs_for_nested_attributes opts, &form_block }
      text = new_record.is_a?(String) ? new_record : I18n.t('active_admin.has_many_new', model: assoc_name.human)

      template.link_to text, '#', class: "button has_many_add", data: {
        html: CGI.escapeHTML(html).html_safe, placeholder: placeholder
      }
    end
  end
end
