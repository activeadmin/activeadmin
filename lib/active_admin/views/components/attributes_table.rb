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

      def content_for(attr_or_proc)
        value = case attr_or_proc
                when Proc
                  attr_or_proc.call(@record)
                else
                  content_for_attribute(attr_or_proc)
                end
        value = pretty_format(value)
        value == "" || value.nil? ? empty_value : value
      end

      def content_for_attribute(attr)
        if attr.to_s =~ /^([\w]+)_id$/ && @record.respond_to?($1.to_sym)
          content_for_attribute($1)
        else
          @record.send(attr.to_sym)
        end
      end
    end

  end
end
