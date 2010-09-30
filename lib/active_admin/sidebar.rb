require 'active_admin/helpers/optional_display'

module ActiveAdmin
  module Sidebar
    extend ActiveSupport::Concern

    included do
      self.class_inheritable_accessor :sidebar_sections
      self.sidebar_sections = []
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
      include ActiveAdmin::OptionalDisplay
  
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

      # If a block is not passed in, the name of the partial to render
      def partial_name
        options[:partial] || "#{name.to_s.downcase.gsub(' ', '_')}_sidebar"
      end
    end

    class Renderer < ActiveAdmin::Renderer
      def to_html(sidebar_sections)
        sidebar_sections.collect do |section|
          title   = content_tag :h3, section.title
          content = content_tag :div, sidebar_content(section)

          content_tag :div, :class => 'sidebar_section', :id => section.id do
            title + content
          end
        end.join
      end

      # If a block exists, render the block. Otherwise render a partial
      def sidebar_content(section)
        if section.block
          instance_eval(&section.block)
        else
          capture do
            render section.partial_name
          end
        end
      end
    end

  end
end
