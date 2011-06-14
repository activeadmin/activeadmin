module ActiveAdmin
  module AssetRegistration

    # Stylesheets

    def register_stylesheet(name)
      stylesheets << name
    end

    def stylesheets
      @stylesheets ||= []
    end

    def clear_stylesheets!
      @stylesheets = []
    end


    # Javascripts

    def register_javascript(name)
      javascripts << name
    end

    def javascripts
      @javascripts ||= []
    end

    def clear_javascripts!
      @javascripts = []
    end

  end
end
