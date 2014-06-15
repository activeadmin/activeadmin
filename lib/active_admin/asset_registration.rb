module ActiveAdmin
  module AssetRegistration

    def register_stylesheet(path, options = {})
      stylesheets[path] = options
    end

    def stylesheets
      @stylesheets ||= {}
    end

    def clear_stylesheets!
      @stylesheets = {}
    end

    def register_javascript(names)
      if names.is_a?Array
        javascripts.merge names
      else
        javascripts.add names
      end
    end

    def javascripts
      @javascripts ||= Set.new
    end

    def clear_javascripts!
      @javascripts = Set.new
    end

  end
end
