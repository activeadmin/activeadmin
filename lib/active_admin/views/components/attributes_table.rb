# frozen_string_literal: true
module ActiveAdmin
  module Views

    class AttributesTable < ActiveAdmin::Component
      builder_method :attributes_table_for

      def build(obj, *attrs)
        @collection = Array.wrap(obj)
        @resource_class = @collection.first.class
        options = {}
        options[:for] = @collection.first if single_record?
        super(options)
        add_class "attributes-table"
        @table = table
        build_colgroups
        rows(*attrs)
      end

      def rows(*attrs)
        attrs.each { |attr| row(attr) }
      end

      def row(*args, &block)
        title = args[0]
        data = args[1] || args[0]
        options = args.extract_options!
        options["data-row"] = title.to_s.parameterize(separator: "_") if title.present?

        @table << tr(options) do
          th do
            header_content_for(title)
          end
          @collection.each do |record|
            td do
              content_for(record, block || data)
            end
          end
        end
      end

      protected

      def default_id_for_prefix
        "attributes_table"
      end

      # Build Colgroups
      #
      # Colgroups are only necessary for a collection of records; not
      # a single record.
      def build_colgroups
        return if single_record?
        reset_cycle(self.class.to_s)
        within @table do
          col # column for row headers
          @collection.each do |record|
            col(id: dom_id_for(record))
          end
        end
      end

      def header_content_for(attr)
        if attr.is_a?(Symbol)
          default = attr.to_s.titleize
          if @resource_class.respond_to?(:human_attribute_name)
            @resource_class.human_attribute_name(attr, default: default)
          else
            default
          end
        else
          attr.to_s
        end
      end

      def empty_value
        span I18n.t("active_admin.empty"), class: "attributes-table-empty-value"
      end

      def content_for(record, attr)
        value = helpers.format_attribute record, attr
        value.blank? && current_arbre_element.children.to_s.empty? ? empty_value : value
        # Don't add the same Arbre twice, while still allowing format_attribute to call status_tag
        current_arbre_element << value unless current_arbre_element.children.include? value
      end

      def single_record?
        @single_record ||= @collection.size == 1
      end
    end

  end
end
