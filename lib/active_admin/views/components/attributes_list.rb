# frozen_string_literal: true
module ActiveAdmin
  module Views
    class AttributesList < ActiveAdmin::Component
      builder_method :attributes_list_for

      def build(obj, *args, **options)
        @resource = obj
        @resource_class = obj.class
        options = args.extract_options!
        @item_options = options.extract!(:group_html, :term_html, :description_html)
        super(options)
        items(*args)
      end

      def tag_name
        "dl"
      end

      def items(*attributes)
        attributes.each { |attribute| item(attribute) }
      end

      def item(*args, &block)
        title = args[0]
        options = args.extract_options!
        group_html = options.delete(:group_html) || @item_options[:group_html] || {}
        term_html = options.delete(:term_html) || @item_options[:term_html] || {}
        description_html = options.delete(:description_html) || @item_options[:description_html] || {}

        div(**group_html) do
          dt(**term_html) do
            if options[:term].is_a?(Proc)
              options[:term].call
            else
              term_content_for(title)
            end
          end
          dd(**description_html) do
            description_content_for(@resource, block || title)
          end
        end
      end

      protected

      def default_class_name
        "attributes_list"
      end

      def term_content_for(attribute)
        if @resource_class.respond_to?(:human_attribute_name)
          @resource_class.human_attribute_name(attribute, default: attribute.to_s.titleize)
        else
          attribute.to_s.titleize
        end
      end

      def description_content_for(record, attribute)
        value = helpers.format_attribute(record, attribute)
        value.blank? && current_arbre_element.children.to_s.empty? ? empty_value : value
        # Don't add the same Arbre twice, while still allowing format_attribute to call status_tag
        current_arbre_element << value unless current_arbre_element.children.include?(value)
      end

      def empty_value
        span I18n.t("active_admin.empty"), class: "empty"
      end
    end
  end
end
