module ActiveAdmin
  class ControllerAction
    attr_reader :name
    def initialize(name, options = {})
      @name, @options = name, options
    end

    def http_verb
      @options[:method] ||= :get
    end
  end
end
