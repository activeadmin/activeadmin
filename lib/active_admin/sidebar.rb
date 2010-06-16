module ActiveAdmin
  module Sidebar

    def self.included(base)
      base.send :extend, ClassMethods
      base.class_inheritable_accessor :sidebar_sections
      base.sidebar_sections = []
    end

    module ClassMethods

      def sidebar(name, options = {}, &block)
        self.sidebar_sections << ActiveAdmin::Sidebar::Section.new(name, options, &block)
      end

      def clear_sidebar_sections!
        self.sidebar_sections = []
      end

      def sidebar_sections_for(action)
        sidebar_sections.select{|section| section.display_on?(action) }
      end
    end

    class Section
  
      attr_accessor :name, :options, :block

      def initialize(name, options = {}, &block)
        @name, @options, @block = name, options, block
        normalize_display_options!
      end

      # The id gets used for the div in the view
      def id
        name.to_s.downcase.underscore + '_sidebar_section'
      end

      # The title gets displayed within the section in the view
      def title
        name.to_s.titlecase
      end

      def display_on?(action)
        return @options[:only].include?(action.to_sym) if @options[:only]
        return !@options[:except].include?(action.to_sym) if @options[:except]
        true
      end

      private

      def normalize_display_options!
        if @options[:only]
          @options[:only] = @options[:only].is_a?(Array) ? @options[:only] : [@options[:only]]
        end
        if @options[:except]
          @options[:except] = @options[:except].is_a?(Array) ? @options[:except] : [@options[:except]]
        end
      end        

    end

    class Renderer < ActiveAdmin::Renderer
      def to_html(sidebar_sections)
        sidebar_sections.collect do |section|
          content_tag :div, :class => 'sidebar_section', :id => section.id do
            title = content_tag :h3, section.title
            content = content_tag :div, instance_eval(&section.block)
            title + content
          end
        end.join.html_safe
      end
    end

  end
end
