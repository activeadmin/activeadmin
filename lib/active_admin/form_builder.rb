# frozen_string_literal: true
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

    def cancel_link(url = { action: "index" }, html_options = {}, li_attrs = {})
      li_attrs[:class] ||= "cancel"
      li_content = template.link_to I18n.t("active_admin.cancel"), url, html_options
      template.content_tag(:li, li_content, li_attrs)
    end

    attr_accessor :already_in_an_inputs_block

    def has_many(assoc, options = {}, &block)
      HasManyBuilder.new(self, assoc, options).render(&block)
    end
  end

  # Decorates a FormBuilder with the additional attributes and methods
  # to build a has_many block.  Nested has_many blocks are handled by
  # nested decorators.
  class HasManyBuilder < SimpleDelegator
    attr_reader :assoc
    attr_reader :options
    attr_reader :heading, :sortable_column, :sortable_start
    attr_reader :new_record, :destroy_option, :remove_record

    def initialize(has_many_form, assoc, options)
      super has_many_form
      @assoc = assoc
      @options = extract_custom_settings!(options.dup)
      @options.reverse_merge!(for: assoc)
      @options[:class] = [options[:class], "inputs has_many_fields"].compact.join(" ")

      if sortable_column
        @options[:for] = [assoc, sorted_children(sortable_column)]
      end
    end

    def render(&block)
      html = "".html_safe
      html << template.content_tag(:h3) { heading } if heading.present?
      html << template.capture { content_has_many(&block) }
      html = wrap_div_or_li(html)
      template.concat(html) if template.output_buffer
      html
    end

    protected

    # remove options that should not render as attributes
    def extract_custom_settings!(options)
      @heading = options.key?(:heading) ? options.delete(:heading) : default_heading
      @sortable_column = options.delete(:sortable)
      @sortable_start = options.delete(:sortable_start) || 0
      @new_record = options.key?(:new_record) ? options.delete(:new_record) : true
      @destroy_option = options.delete(:allow_destroy)
      @remove_record = options.delete(:remove_record)
      options
    end

    def default_heading
      assoc_klass.model_name.
        human(count: ::ActiveAdmin::Helpers::I18n::PLURAL_MANY_COUNT)
    end

    def assoc_klass
      @assoc_klass ||= __getobj__.object.class.reflect_on_association(assoc).klass
    end

    def content_has_many(&block)
      form_block = proc do |form_builder|
        render_has_many_form(form_builder, options[:parent], &block)
      end

      template.assigns[:has_many_block] = true
      contents = without_wrapper { inputs(options, &form_block) }
      contents ||= "".html_safe

      js = new_record ? js_for_has_many(options[:class], &form_block) : ""
      contents << js
    end

    # Renders the Formtastic inputs then appends ActiveAdmin delete and sort actions.
    def render_has_many_form(form_builder, parent, &block)
      index = parent && form_builder.send(:parent_child_index, parent)
      template.concat template.capture { yield(form_builder, index) }
      template.concat has_many_actions(form_builder, "".html_safe)
    end

    def has_many_actions(form_builder, contents)
      if form_builder.object.new_record?
        contents << template.content_tag(:li) do
          remove_text = remove_record.is_a?(String) ? remove_record : I18n.t("active_admin.has_many_remove")
          template.link_to remove_text, "#", class: "button has_many_remove"
        end
      elsif allow_destroy?(form_builder.object)
        form_builder.input(
          :_destroy, as: :boolean,
                     wrapper_html: { class: "has_many_delete" },
                     label: I18n.t("active_admin.has_many_delete"))
      end

      if sortable_column
        form_builder.input sortable_column, as: :hidden

        contents << template.content_tag(:li, class: "handle") do
          I18n.t("active_admin.move")
        end
      end

      contents
    end

    def allow_destroy?(form_object)
      !! case destroy_option
         when Symbol, String
           form_object.public_send destroy_option
         when Proc
           destroy_option.call form_object
         else
           destroy_option
         end
    end

    def sorted_children(column)
      __getobj__.object.public_send(assoc).sort_by do |o|
        attribute = o.public_send column
        [attribute.nil? ? Float::INFINITY : attribute, o.id || Float::INFINITY]
      end
    end

    def without_wrapper
      is_being_wrapped = already_in_an_inputs_block
      self.already_in_an_inputs_block = false

      html = yield

      self.already_in_an_inputs_block = is_being_wrapped
      html
    end

    # Capture the ADD JS
    def js_for_has_many(class_string, &form_block)
      assoc_name = assoc_klass.model_name
      placeholder = "NEW_#{assoc_name.to_s.underscore.upcase.gsub(/\//, '_')}_RECORD"
      opts = {
        for: [assoc, assoc_klass.new],
        class: class_string,
        for_options: { child_index: placeholder }
      }
      html = template.capture { __getobj__.send(:inputs_for_nested_attributes, opts, &form_block) }
      text = new_record.is_a?(String) ? new_record : I18n.t("active_admin.has_many_new", model: assoc_name.human)

      template.link_to text, "#", class: "button has_many_add", data: {
        html: CGI.escapeHTML(html).html_safe, placeholder: placeholder
      }
    end

    def wrap_div_or_li(html)
      template.content_tag(
        already_in_an_inputs_block ? :li : :div,
        html,
        class: "has_many_container #{assoc}",
        "data-sortable" => sortable_column,
        "data-sortable-start" => sortable_start)
    end
  end
end
