module ActiveAdmin
  class ControllerAction
    
    attr_reader :options
    
    def initialize(name, options = {})
      options[:action] = name
      @name, @options = name, options
    end

    def http_verb
      @options[:method] ||= :get
    end
    
    def name
      @options[:as] || @name
    end
    
  end
end
