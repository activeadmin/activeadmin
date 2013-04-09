module ActiveAdmin

  class SidebarSection
    include ActiveAdmin::OptionalDisplay

    attr_accessor :name, :options, :block

    def initialize(name, options = {}, &block)
      @name, @options, @block = name, options, block
      normalize_display_options!
    end

    # The id gets used for the div in the view
    def id
      "#{name.to_s.downcase.underscore}_sidebar_section".parameterize
    end

    def icon?
      !!options[:icon]
    end

    def icon
      options[:icon] if icon?
    end

    # The title gets displayed within the section in the view
    def title
      I18n.t("active_admin.sidebars.#{name.to_s}", :default => name.to_s.titlecase)
    end

    # If a block is not passed in, the name of the partial to render
    def partial_name
      options[:partial] || "#{name.to_s.downcase.gsub(' ', '_')}_sidebar"
    end
  end

end
