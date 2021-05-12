# frozen_string_literal: true
module ActiveAdmin
  module AssetRegistration

    def register_stylesheet(path, options = {})
      stylesheets[path] = options
    end

    def stylesheets
      @stylesheets ||= {}
    end

    def clear_stylesheets!
      stylesheets.clear
    end

    def register_javascript(name)
      javascripts.add name
    end

    def javascripts
      @javascripts ||= Set.new
    end

    def clear_javascripts!
      javascripts.clear
    end

  end
end
