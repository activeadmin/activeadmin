module ActiveAdmin
  module AssetRegistration

    # Stylesheets

    def register_stylesheet(*args)
      stylesheets << ActiveAdmin::Stylesheet.new(*args)
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
  
  # Wrapper class for stylesheet registration
  class Stylesheet
    
    attr_reader :options, :path
    
    def initialize(*args)
      @options = args.extract_options!
      @path = args.first if args.first
    end
    
  end
  
end
