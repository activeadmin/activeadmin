module ActiveAdmin
  module Views

    class AttributesTable < ActiveAdmin::Component
      builder_method :attributes_table_for

      attr_reader :resource

      def build(record, *attrs)
        @record = record
        super(:for => @record)
        @table = table
        rows(*attrs)
      end

      def rows(*attrs)
        attrs.each {|attr| row(attr) }
      end

      def row(*args, &block)
        title   = args[0]
        options = args.extract_options!
        options[:class] ||= :row
        @table << tr(options) do
          th do
            header_content_for(title)
          end
          td do
            content_for(block || title)
          end
        end
      end

      protected

      def default_id_for_prefix
        'attributes_table'
      end

      def header_content_for(attr)
        if @record.class.respond_to?(:human_attribute_name)
          @record.class.human_attribute_name(attr, :default => attr.to_s.titleize)
        else
          attr.to_s.titleize
        end
      end

      def empty_value
        span I18n.t('active_admin.empty'), :class => "empty"
      end

      def content_for(attr)
        previous = current_arbre_element.to_s
        value    = pretty_format find_attr_value attr
        value.blank? && previous == current_arbre_element.to_s ? empty_value : value
      end

      def find_attr_value(attr)
        if attr.is_a?(Proc)
          attr.call(@record)
        elsif attr.to_s[/\A(.+)_id\z/] && @record.respond_to?($1.to_sym)
          @record.send($1.to_sym)
        else
          @record.send(attr.to_sym)
        end
      end
    end

  end
end
