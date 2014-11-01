require 'active_admin/iconic/icons'

module ActiveAdmin
  module Iconic

    # Default color to use for icons
    @@default_color = "#5E6469"
    mattr_accessor :default_color


    # Render an icon:
    #   Iconic.icon :loop, width: 100, height: 100, color: "#5E6469"
    #   Iconic.icon :loop, width: "1em", height: "1em", color: "#5E6469"
    # NOTE: you can omit the dimensions if they are specified in css
    def self.icon(name, options = {})
      options = {
        color: default_color,
        id: ""
      }.merge(options)

      options[:style] = "fill:#{options[:color]};"
      options[:fill] = options.delete(:color)

      css = options.delete(:css) || {}

      # extract desired dimensions to be used as the wrapper's inline styles
      # Convert to strings representations of pixels
      [:width, :height].each do |key|
        value = options.delete key
        css[key] ||= "#{value}px" unless value.blank? || value.is_a?(String)
      end
      css_str = css.map {|k,v| "#{k}:#{v}"}.join(";")
      css_str = "style=\"#{css_str}\"" if css_str.present?

      # make the svg itself expand to its parent
      options[:width] = options[:height] = "100%"

      template = ICONS[name.to_sym]

      if template
        svg = template.dup
        options.each do |key, value|
          svg.gsub!("{#{key}}", value)
        end

        "<span class=\"icon icon_#{name}\" #{css_str}>#{svg}</span>".html_safe
      else
        raise "Could not find the icon named #{name}"
      end
    end

  end
end
