require 'active_admin/iconic/icons'

module ActiveAdmin
  module Iconic

    # Default color to use for icons
    @@default_color = "#5E6469"
    mattr_accessor :default_color

    # Default width to use for icons
    @@default_width = 15
    mattr_accessor :default_width

    # Default height to use for icons
    @@default_height = 15
    mattr_accessor :default_height

    # Render an icon:
    #   Iconic.icon :loop
    def self.icon(name, options = {})
      options = {
        :color => default_color,
        :width => default_width,
        :height => default_height,
        :id => ""
      }.merge(options)


      options[:style] = "fill:#{options[:color]};"
      options[:fill] = options.delete(:color)

      # Convert to strings representations of pixels
      [:width, :height].each do |key|
        options[key] = "#{options[key]}px" unless options[key].is_a?(String)
      end

      template = ICONS[name.to_sym]

      if template
        svg = template.dup
        options.each do |key, value|
          svg.gsub!("{#{key}}", value)
        end
        "<span class=\"icon icon_#{name}\">#{svg}</span>".html_safe
      else
        raise "Could not find the icon named #{name}"
      end
    end

  end
end
