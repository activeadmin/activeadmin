module ActiveAdmin
  module AssetRegistration

    def register_stylesheet(name)
      stylesheets << name
    end

    def stylesheets
      @@stylesheets ||= []
    end

    def register_javascript(name)
      javascripts << name
    end

    def javascripts
      @@javascripts ||= []
    end
    
  end
end
