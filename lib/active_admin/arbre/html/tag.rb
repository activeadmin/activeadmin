require 'erb'

module Arbre
  module HTML

    class Tag < Element
      attr_reader :attributes

      def initialize(*)
        super
        @attributes = Attributes.new
      end

      def build(*args)
        super
        attributes = args.extract_options!
        self.content = args.first if args.first

        set_for_attribute(attributes.delete(:for))

        attributes.each do |key, value|
          set_attribute(key, value)
        end
      end

      def set_attribute(name, value)
        @attributes[name.to_sym] = value
      end

      def get_attribute(name)
        @attributes[name.to_sym]
      end
      alias :attr :get_attribute

      def has_attribute?(name)
        @attributes.has_key?(name.to_sym)
      end

      def remove_attribute(name)
        @attributes.delete(name.to_sym)
      end

      def id
        get_attribute(:id)
      end

      # Generates and id for the object if it doesn't exist already
      def id!
        return id if id
        self.id = object_id.to_s
        id
      end

      def id=(id)
        set_attribute(:id, id)
      end

      def add_class(class_names)
        class_list.add class_names
      end

      def remove_class(class_names)
        class_list.delete(class_names)
      end

      # Returns a string of classes
      def class_names
        class_list.to_html
      end

      def class_list
        get_attribute(:class) || set_attribute(:class, ClassList.new)
      end

      def to_html
        indent("<#{tag_name}#{attributes_html}>", content, "</#{tag_name}>").html_safe
      end

      private

      INDENT_SIZE = 2
      
      def indent(open_tag, child_content, close_tag)
        spaces = ' ' * indent_level * INDENT_SIZE

        html = ""

        if no_child? || child_is_text?
          if self_closing_tag?
            html << spaces << open_tag.sub( />$/, '/>' )
          else
            # one line
            html << spaces << open_tag << child_content << close_tag
          end
        else
          # multiple lines
          html << spaces << open_tag << "\n"
          html << child_content # the child takes care of its own spaces
          html << spaces << close_tag
        end

        html << "\n"

        html
      end
      
      def self_closing_tag?
        %w|meta link|.include?(tag_name)
      end
      
      def no_child?
        children.empty?
      end

      def child_is_text?
        children.size == 1 && children.first.is_a?(TextNode)
      end


      def attributes_html
        attributes.any? ? " " + attributes.to_html : nil
      end

      def set_for_attribute(record)
        return unless record
        set_attribute :id, ActionController::RecordIdentifier.dom_id(record, default_id_for_prefix)
        add_class ActionController::RecordIdentifier.dom_class(record)
      end

      def default_id_for_prefix
        nil
      end

    end

  end
end
